module Pinky
  module CachableModel
    def self.extended base
      base.send :include, ModelNaturalKeyMethods unless base.include? ModelNaturalKeyMethods
    end

    def update_cache_with item_hash, action
      item = new item_hash
      cache.delete item.natural_key
      cache[item.natural_key] = item unless action.to_sym == :destroy
    end

    def clear_cache
      @cache = nil
    end

    private
    def cache
      @cache ||= Hash.new { |cache_hash, nat_key| add_many(from_wire(nat_key)) }
    end

    def add_many items
      Array(items).each { |item_hash| update_cache_with item_hash, :create }
    end
  end
end
