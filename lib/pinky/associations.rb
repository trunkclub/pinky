module Pinky
  module Associations
    def has_one klass, opts = {}
      klass_name = klass.name.split('::').last.downcase
      find_by          = opts[:lookup_by] || "#{klass_name}_id"
      association_name = opts[:as] || klass_name
      define_method association_name do
        begin
          klass.find :id => send(find_by)
        rescue NotFoundException
          raise unless opts[:allow_nil]
        end
      end
    end
  end
end
