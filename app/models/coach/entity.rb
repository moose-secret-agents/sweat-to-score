require 'ostruct'

module Coach
  class Entity < Hashie::Dash
    include Hashie::Extensions::IndifferentAccess
    include HTTParty

    property :uri
    property :id
    property :datecreated
    property :publicvisible

    headers  'Accept' => 'application/json'
    debug_output $stdout if Rails.env == 'development'
    base_uri 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources'

    # Fetch an entity based on its uri
    def fetch
      return self if @fetched

      raise 'Entity has not been loaded yet and does not have "uri" property' if self.uri.blank?

      response = Entity.get clean_uri
      update_attributes! JSON.parse(response.body)

      @fetched = true
      self
    end

    def clean_uri
      self.uri.gsub('/CyberCoachServer/resources', '')
    end
  end
end