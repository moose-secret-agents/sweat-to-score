require 'ostruct'

module Coach
  class Entity < Hashie::Trash
    include Hashie::Extensions::IndifferentAccess
    include HTTParty

    property :uri
    property :id
    property :created_at, from: :datecreated
    property :visibility, from: :publicvisible

    headers  'Accept' => 'application/json'
    debug_output $stdout if Rails.env == 'development'
    base_uri 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources'

    class << self
      def authenticated(username, password, &block)
        @auth = { username: username, password: password }
        res = instance_eval &block
        @auth = nil
        res
      end
    end

    # Fetch an entity based on its uri. Each entity containing a valid uri will be retrievable through this method
    def fetch
      return self if @fetched
      raise 'Entity has not been loaded yet and does not have "uri" property' if self.uri.blank?

      response = Entity.get clean_uri
      update_attributes! JSON.parse(response.body)

      @fetched = true
      self
    end

    # Remove overlapping url parts
    def clean_uri
      self.uri.gsub('/CyberCoachServer/resources', '')
    end
  end
end