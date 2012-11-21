module Pinky
  module EnergizerBunny
    module Config
      module HasDefaults
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def defaults
            raise Exception.new('HasDefaults requires Class methods defaults to be defined')
          end

          def defaultable(*method_names)
            method_names.each do |method_name|
              instance_variable = "@#{method_name}"
              define_method(method_name) do
                instance_variable_get(instance_variable) || defaults[method_name]
              end

              define_method("#{method_name}=") do |value|
                instance_variable_set(instance_variable, value)
              end
            end
          end
        end

        def defaults
          self.class.defaults
        end
      end
    end
  end
end
