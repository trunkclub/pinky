module Pinky
  class Cache
    extend Forwardable

    attr_reader :name
    def_delegators :cache, :size, :count, :empty?

    class << self
      def name_for(*methods)
        "cache_by_#{methods.flatten.sort.join("_and_")}"
      end
    end

    def initialize(*item_methods)
      @item_methods = item_methods.flatten.sort
      @name = self.class.name_for(@item_methods)
    end

    def queryable_for?(query_hash)
      query_hash.keys.sort == @item_methods
    end

    def update_with(item, action = :create)
      key = key_for item
      if action == :destroy
        cache.delete key
      else
        cache[key] = item
      end
    end

    def query(query_hash = {})
      key = query_hash.sort.map { |k,v| v }.join '.'
      cache[key]
    end

    def clear_cache
      @cache = nil
    end

    private
    def key_for(item)
      @item_methods.map { |method| item.send method }.join '.'
    end

    def cache
      @cache ||= {}
    end
  end
end
