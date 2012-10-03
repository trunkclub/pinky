module Pinky
  module Model
    def self.included base
      base.extend ClassMethods
      base.extend ModelFetchMethods
    end

    def initialize hash
      @hash = hash
      hash.keys.each do |method|
        define_singleton_method method do
          @hash[method]
        end
      end
    end

    def natural_key
      natural_key_methods.map { |method_name| send method_name }.join natural_key_separator
    end

    private
    def natural_key_methods
      self.class.natural_key
    end

    def natural_key_separator
      self.class.natural_key_separator
    end

    module ClassMethods
      def natural_key *methods
        return @natural_key if methods.empty?
        @natural_key = methods
      end

      def natural_key_separator sep = nil
        return @natural_key_separator || '.' if sep.nil?
        @natural_key_separator = sep
      end

      # TODO
      #def preload
      #end
    end

  end
end
