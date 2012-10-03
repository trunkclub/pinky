module Pinky
  module ModelFetchMethods
    def self.included base
      base.send :include, ModelNaturalKeyMethods unless base.response_to? :natural_key
    end

    def find natural_key
      cache[natural_key.to_s]
    end

    def fetch_url url, fetch_opts = {}
      @fetch_url = url
      @fetch_opts = fetch_opts
    end

    def clear_cache
      @cache = nil
    end

    private
    def cache
      @cache ||= Hash.new { |cache_hash, nat_key| add_to(cache_hash, from_wire(nat_key)) }
    end

    def add_to cache, items
      Array(items).each do |item_hash|
        item = new item_hash
        cache[item.natural_key] = item
      end
    end

    def from_wire natural_key
      url = _fetch_url_for natural_key
      response = HTTParty.get url
      response = JSON.parse(response.body)
      raise Exception.new "Error fetching from #{url}#{$/}#{response['errors'].join ','}" unless response['success']
      response = response['response']
      response = response.fetch @fetch_opts[:response_key] if @fetch_opts[:response_key]
      response
    end

    def _fetch_url_for natural_key
      raise Exception.new "You must specify a fetch_url for #{self.name}" unless @fetch_url
      @fetch_url.dup.sub /:natural_key/, natural_key.to_s
    end
  end
end
