module Pinky
  module EnergizerBunny
    class Message < String
      def initialize(headers, message_data)
        super message_data
        @headers = headers
      end

      def headers
        properties.headers
      end

      def ack
        @headers.ack
      end

      def reject(opts = {})
        @headers.reject :requeue => opts.fetch(:requeue, false)
      end

      def requeue
        @headers.reject :requeue => true
      end

      private
      def properties
        @headers.properties
      end
    end
  end
end
