module Coach
  class User < Coach::Entity

    property :username
    property :password
    property :real_name, from: :realname
    property :email
    property :partnerships
    property :subscriptions

    alias_method :old_partnerships, :partnerships
    alias_method :old_subscriptions, :subscriptions

    class << self
      # Find all users on server. Pass :eager option to return results eagerly (slow)
      # Pass :search option to only include users matching the search query
      def all(options={})
        eager, search = options.values_at(:eager, :search)
        response = get '/users', query: { searchCriteria: search }
        JSON.parse(response.body)['users'].map { |u| eager ? Coach::User.new(u).fetch : Coach::User.new(u) }
      end

      # Find user by username
      def find(username)
        response = get "/users/#{username}", basic_auth: @auth
        response.code == 200 ? Coach::User.new(JSON.parse(response.body)) : nil
      end

      # Check whether user exists
      def exists?(username)
        !!find(username)
      end

      def authenticated?(username, password)
        authenticated(username, password) do
          response = get '/authenticateduser', basic_auth: @auth
          response.code == 200 ? Coach::User.new(JSON.parse(response.body)) : nil
        end
      end

      # Create new user
      def create(username, attributes={})
        response = put "/users/#{username}", body: attributes
        response.code == 201 ? Coach::User.new(JSON.parse(response.body)) : nil
      end

      # Update user
      def update(username, attributes={})
        response = put "/users/#{username}", body: attributes, basic_auth: @auth
        response.code == 200 ? Coach::User.new(JSON.parse(response.body)) : nil
      end

      # Delete user
      def delete(username)
        HTTParty::delete "/users/#{username}", basic_auth: @auth
      end
    end

    def partnerships
      old_partnerships.map { |p| Coach::Partnership.new(p).fetch }
    end

    def subscriptions
      old_subscriptions.map { |p| Coach::Subscription.new(p).fetch }
    end
  end
end