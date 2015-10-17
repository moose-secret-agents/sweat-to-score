module Coach
  class User < Coach::Entity

    property :username
    property :password
    property :realname
    property :email
    property :partnerships
    property :subscriptions

    alias_method :real_name, :realname
    alias_method :old_partnerships, :partnerships
    alias_method :old_subscriptions, :subscriptions

    # Find all users on server. Set eager to true if you want all user attributes to be fetched from the beginning (slow)
    def self.all(eager=false)
      response = get '/users'
      JSON.parse(response.body)['users'].map { |u| eager ? Coach::User.new(u).fetch : Coach::User.new(u) }
    end

    # Find user by username
    def self.find(username, password=nil)
      auth = { username: username, password: password }
      response = get "/users/#{username}", basic_auth: auth
      response.code == 200 ? Coach::User.new(JSON.parse(response.body)) : nil
    end

    # Check whether user exists
    def self.exists?(username)
      !!find(username)
    end

    # Create new user
    def self.create(username, attributes={})
      put "/users/#{username}", body: attributes
    end

    # Update user
    def self.update(username, password, attributes={})
      auth = { username: username, password: password }
      put "/users/#{username}", body: attributes, basic_auth: auth
    end

    # Delete user
    def self.delete(username, password)
      auth = { username: username, password: password }
      HTTParty::delete "/users/#{username}", basic_auth: auth
    end

    def partnerships
      old_partnerships.map { |p| Coach::Partnership.new(p)}
    end

    def subscriptions
      old_subscriptions.map { |p| Coach::Subscription.new(p)}
    end
  end
end