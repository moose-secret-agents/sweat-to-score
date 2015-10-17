require 'ostruct'

module Coach
  class Entity < OpenStruct # < ActiveRestClient::Base
    include HTTParty
    # Use JSON parser in response
    #format :json
    # Request JSON response from server
    headers  'Accept' => 'application/json'

    debug_output $stdout

    base_uri 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources'
  end
end