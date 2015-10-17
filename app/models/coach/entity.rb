require 'ostruct'

module Coach
  class Entity < OpenStruct # < ActiveRestClient::Base
    include HTTParty

    headers  'Accept' => 'application/json'
    debug_output $stdout
    base_uri 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources'

    # Fetch an entity based on its uri
    def fetch
      return self if @fetched

      raise 'Entity has not been loaded yet and does not have "uri" property' if self.uri.blank?

      response = Entity.get clean_uri
      instance = self.class.new(JSON.parse(response.body))

      @fetched = true

      instance
    end

    def clean_uri
      self.uri.gsub('/CyberCoachServer/resources', '')
    end
  end
end