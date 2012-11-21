require File.expand_path('../has_defaults', __FILE__)

module Pinky
  module EnergizerBunny
    module Config

      class Queue
        include HasDefaults

        #class << self
          #def defaults
            #@defaults ||= {
              #:auto_delete => false,
              #:durable     => false
            #}
          #end
        #end

        attr_reader :reference_key, :name

        def initialize(reference_key, name)
          @reference_key, @name = reference_key, name
        end
      end
    end
  end
end
