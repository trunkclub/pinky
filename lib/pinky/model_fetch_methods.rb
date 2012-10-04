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
      @fetch_url    = url
      @fetch_opts   = fetch_opts
      @response_key = @fetch_opts.delete :response_key
    end

    private
    def from_wire natural_key
      url = _fetch_url_for natural_key
      response = HTTParty.get url, @fetch_opts
      response = JSON.parse(response.body)
      raise Exception.new "Error fetching from #{url}#{$/}#{response['errors'].join ','}" unless response['success']
      response = response['response']
      response = response.fetch @response_key if @response_key
      raise Exception.new "More than one model was returned" if response.size != 1
      response.first
    end

    def _fetch_url_for natural_key
      raise Exception.new "You must specify a fetch_url for #{self.name}" unless @fetch_url
      @fetch_url.dup.sub /:natural_key/, natural_key.to_s
    end
  end
end
