module Pinky
  module EnergizerBunny
    class Configurations
      class << self
        def clear_all
          @exchanges = nil
        end

        def add_exchange(reference_key, exchange_config)
          exchanges[reference_key] = exchange_config
        end

        def exchange(reference_key)
          exchanges[reference_key] || raise(Exception.new("Exchange referenced by '#{reference_key}' has not been defined"))
        end

        private
        def exchanges
          @exchanges ||= {}
        end
      end
    end
  end
end
