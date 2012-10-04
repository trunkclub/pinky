module Pinky
  module CachableModel
    def self.extended base
      base.send :include, ModelNaturalKeyMethods unless base.include? ModelNaturalKeyMethods
    end

    def update_cache_with item_hash, action
      item = new item_hash
      cache.delete item.natural_key
      cache[item.natural_key] = item unless action.to_sym == :destroy
      item
    end

    def clear_cache
      @cache = nil
    end

    private
    def cache
      @cache ||= Hash.new { |cache_hash, nat_key| update_cache_with from_wire(nat_key), :create }
    end
  end
end
