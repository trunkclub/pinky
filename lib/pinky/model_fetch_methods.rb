module Pinky
  module ModelFetchMethods
    def self.extended(base)
      base.extend HasCaches unless base.is_a? HasCaches
    end

    def find(query_hash = {})
      query_hash = { :id => query_hash } unless query_hash.is_a?(Hash)
      cache_name = Cache.name_for(*query_hash.keys)
      raise NotFoundException.new unless cache = pinky_caches_by_name[cache_name]
      found_object = cache.query(query_hash)
      return found_object unless found_object.nil?
      item_hash = lookup_item_hash query_hash
      update_caches_with item_hash
    end

    private
    def lookup_item_hash(query)
      response = HTTParty.get pinky_request_url(query),
        :query   => pinky_request_query_params(query),
        :headers => pinky_request_headers(query)
      raise Exception.new 'Error fetching from results' unless response.success?
      response_hash = hash_from_pinky_response(response) rescue nil
      if response_hash.is_a?(Array)
        raise TooManyFoundException.new "More than one model was returned" if response_hash.size > 1
        response_hash = response_hash.first
      end
      raise NotFoundException.new "No model found for query #{query.inspect}" if response_hash.nil?
      response_hash
    end

    def hash_from_pinky_response(response)
      response
    end

    def pinky_request_hostname(query)
      raise Exception.new 'Please provide a hostname via: pinky_request_hostname'
    end

    def pinky_request_path(query)
      "/#{name.to_s.downcase}"
    end

    def pinky_request_headers(query)
      {}
    end

    def pinky_request_query_params(query)
      #query.map { |k,v| "#{k}=#{v}" }.join('&')
      query
    end

    def pinky_request_url(query)
      "#{pinky_request_hostname(query)}#{pinky_request_path(query)}"
    end
  end
end
