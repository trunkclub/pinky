require File.expand_path('../subscription', __FILE__)

module Pinky
  module EnergizerBunny
    class ConfigurationError < StandardError ; end

    class Connection
      def initialize config, logger = Rails.logger
        @config = config
        @logger = logger
        return unless enabled?
        at_exit { close }
        @exchanges = Hash.new { |exchanges, topic_key| exchanges[topic_key] = create_exchange topic_key }
        @queues    = Hash.new { |queues, topic_key|    queues[topic_key]    = create_queue topic_key }
        @subscriptions = []
        create_connection
      end

      def subscribe topic_key, subscription_opts = {}, &block
        return unless enabled?
        @subscriptions << Subscription.new(@queues[topic_key], subscription_opts, @logger, block)
      end

      def publish topic_key, message, opts = {}
        add_message_id_to_header! opts
        @exchanges[topic_key].publish message, opts if enabled?
      end

      def connected?
        @connection && @connection.open?
      end

      def enabled?
        @config[:enabled]
      end

      def connection_url
        @config[:broker][:url]
      end

      private
      def create_exchange topic_key
        exchange_hash = @config[:exchanges][topic_key]
        channel.exchange exchange_hash[:name], exchange_hash[:opts]
      end

      def create_connection
        url = connection_url
        raise ConfigurationError.new('Please set a broker url for RabbitMQ') if enabled? && url.nil?
        @logger.info "Connecting bunny to: #{url}"
        @connection = HotBunnies.connect :uri => url
      end

      #TODO: is having one channel bad, should this be one per exchange?
      def channel
        @channel ||= @connection.create_channel.tap { |c| c.prefetch = (@config.delete(:prefetch_count) || 1) }
      end

      def create_queue topic_key
        queue_hash = @config[:queues][topic_key]
        raise ConfigurationError.new("Cannot find queue configuration for queue: #{topic_key}") if queue_hash.nil?
        queue_opts = queue_hash[:opts]
        queue_opts[:durable] = true unless queue_opts.key? :durable
        channel.queue(queue_hash[:name], queue_opts).tap do |queue|
          queue_bind_opts = queue_hash[:bind_opts] || {}
          Array(queue_hash[:bindings]).each do |binding|
            binding_opts = queue_bind_opts.merge(binding[:binding_opts] || {})
            queue.bind @exchanges[binding[:exchange_topic_key]], binding_opts
          end
        end
      end

      def close
        @logger.info 'Closing rabbit connection'
        @subscriptions.each &:close
        return unless connected?
        if @channel
          @channel.close
          @channel = nil
        end
        @connection.close
        @connection = nil
      end

      def add_message_id_to_header!(opts)
        opts[:headers] ||= {}
        opts[:headers]['message_id'] ||= guid_generator.generate
      end

      def guid_generator
        @guid_generator ||= UUID.new
      end
    end
  end
end
