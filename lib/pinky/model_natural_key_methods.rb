module Pinky
  module ModelNaturalKeyMethods
    def self.included base
      base.extend ClassMethods
    end

    def natural_key
      natural_key_methods.map { |method_name| send method_name }.join natural_key_separator
    end

    private
    def natural_key_methods
      self.class.natural_key or raise Exception.new('You must specify a natural_key, ex: natural_key :first_name, :last_name')
    end

    def natural_key_separator
      self.class.natural_key_separator
    end

    module ClassMethods
      def natural_key *methods
        return @natural_key if methods.nil? || methods.empty?
        @natural_key = methods
      end

      def natural_key_separator sep = nil
        return @natural_key_separator || '.' if sep.nil?
        @natural_key_separator = sep
      end

    end

  end
end
