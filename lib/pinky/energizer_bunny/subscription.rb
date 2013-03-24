module Pinky
  module EnergizerBunny
    class Subscription
      import java.util.concurrent.Executors

      def initialize queue, subscription_opts, logger, handle_message
        @queue, @subscription_opts, @logger, @handle_message = queue, subscription_opts.dup, logger, handle_message
        @reraise_errors = @subscription_opts.delete(:reraise_errors)
        @subscription_opts[:executor] = executor unless @subscription_opts[:executor]
        listen!
      end

      def close
        close_executor
        return if @subscription.nil?
        @subscription.shutdown!
        @subscription = nil
      end

      private
      def listen!
        @subscription = @queue.subscribe(@subscription_opts) do |headers, msg|
          begin
            @handle_message.call headers.properties.headers, msg
            headers.ack
          rescue => e
            @logger.error "!!!Error handling message: #{e.message}"
            headers.nack
            raise if @reraise_errors
          end
        end
        self
      end

      def log_error e
        @logger.error "An error has occured on another thread: #{e}#{$/}#{e.backtrace}"
      end

      def thread_pool_size
        @thread_pool_size ||= (@subscription_opts.delete(:thread_pool_size) || 1)
      end

      def executor
        @executor ||= Executors.new_fixed_thread_pool(thread_pool_size)
      end

      def close_executor
        return unless @executor
        @executor.shutdown_now
        @executor = nil
      end
    end
  end
end
