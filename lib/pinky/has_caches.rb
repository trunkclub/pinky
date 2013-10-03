module Pinky  
  module HasCaches
    def cachable_by(opts)
      create_cache_for opts[:method_names], opts[:capacity]
    end

    def update_caches_with(item_hash, action = :create)
      item = new item_hash
      pinky_caches.each { |cache| cache.update_with item, action }
      item
    end

    def clear_caches
      pinky_caches.each(&:clear_cache)
    end

    private
    def create_cache_for(method_names, capacity)
      cache = Cache.new(method_names, capacity || 100)
      pinky_caches_by_name[cache.name] = cache
    end

    def pinky_caches_by_name
      @pinky_caches_by_name ||= {}
    end

    def pinky_caches
      pinky_caches_by_name.values
    end
  end
end
