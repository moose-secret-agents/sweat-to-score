module Coach
  class User < Coach::Entity
    def self.all
      get '/users'
    end

    def self.find(username, password=nil)
      auth = { username: username, password: password }
      response = get "/users/#{username}", basic_auth: auth
      if response.code == 200
        Coach::User.new(JSON.parse(response.body))
      else
        nil
      end
    end

    def self.exists?(username)
      !!find(username)
    end

    def self.create(username, attributes={})
      put "/users/#{username}", body: attributes
    end

    def self.update(username, password, attributes={})
      auth = { username: username, password: password }
      put "/users/#{username}", body: attributes, basic_auth: auth
    end

    def self.delete(username, password)
      auth = { username: username, password: password }
      HTTParty::delete "/users/#{username}", basic_auth: auth
    end
  end
end