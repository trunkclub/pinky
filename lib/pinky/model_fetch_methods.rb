module Pinky
  module ModelFetchMethods
    def self.extended base
      base.send :include, ModelNaturalKeyMethods unless base.include? ModelNaturalKeyMethods
      base.extend CachableModel unless base.is_a? CachableModel
    end

    def find natural_key
      cache[natural_key.to_s]
    end

    def fetch_url url, fetch_opts = {}
      @fetch_url  = url
      @fetch_opts = fetch_opts
    end

    private
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
