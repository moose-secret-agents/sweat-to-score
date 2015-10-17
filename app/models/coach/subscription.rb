module Coach
  class Subscription < Coach::Entity
    property :datesubscribed
    property :sport
    property :user
    property :entries

    alias_method :old_user, :user

    def user
      Coach::User.new(old_user).fetch
    end
  end
end
