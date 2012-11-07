module Pinky
  module EnergizerBunny
    class Subscription
      include Mailbox
      mailbox_thread_pool_size 1

      def initialize queue, subscription_opts, logger, handle_message
        @queue, @subscription_opts, @logger, @handle_message = queue, subscription_opts, logger, handle_message
        listen!
      end

      def close
        return if @subscription.nil?
        @subscription.shutdown!
        @subscription = nil
      end

      private
      def listen!
        @subscription = @queue.subscribe(@subscription_opts) do |headers, msg|
          handle_message_on_other_thread headers, msg
          headers.ack
        end
        self
      end

      mailslot :exception => :log_error
      def handle_message_on_other_thread headers, msg
        @handle_message.call headers.properties.headers, msg
      end

      def log_error e
        @logger.error "An error has occured on another thread: #{e}#{$/}#{e.backtrace}"
      end
    end
  end
end
