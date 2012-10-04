module Pinky
  module Associations
    def has_one klass, opts = {}
      klass_name = klass.name.split('::').last.downcase
      find_by = opts[:lookup_by] || "#{klass_name}_id"
      define_method klass_name do
        klass.find send(find_by)
      end
    end
  end
end
