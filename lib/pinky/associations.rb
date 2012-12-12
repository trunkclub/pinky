module Pinky
  module Associations
    def has_one klass, opts = {}
      klass_name = klass.name.split('::').last.downcase
      find_by          = opts[:lookup_by] || "#{klass_name}_id"
      association_name = opts[:as] || klass_name
      define_method association_name do
        lookup_value = send(find_by)
        association_model = lookup_value.nil? ? nil : klass.find(:id => lookup_value) rescue nil
        raise NotFoundException.new if association_model.nil? && !opts[:allow_nil]
      end
    end
  end
end
