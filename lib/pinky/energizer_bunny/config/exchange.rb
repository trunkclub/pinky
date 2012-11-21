require File.expand_path('../has_defaults', __FILE__)

module Pinky
  module EnergizerBunny
    module Config

      class Exchange
        include HasDefaults

        class << self
          def defaults
            @defaults ||= {
              :auto_delete => false,
              :durable     => false
            }
          end
        end

        attr_reader :reference_key, :name, :type
        defaultable :auto_delete, :durable

        def initialize(reference_key, name, type)
          @reference_key, @name, @type = reference_key, name, type
          Configurations.add_exchange(@reference_key, self)
          yield self if block_given?
        end

        def opts
          {
            :type => type,
            :auto_delete => auto_delete,
            :durable => durable
          }
        end

      end

      class HeadersExchange < Exchange
        def initialize(reference_key, name)
          super reference_key, name, :headers
        end
      end
    end
  end
end
