module Coach
  class Partnership < Coach::Entity
    property :confirmed_by_user1, from: :userconfirmed1
    property :confirmed_by_user2, from: :userconfirmed2
    property :user1
    property :user2

    alias_method :old_user1, :user1
    alias_method :old_user2, :user2

    def user1
      User.new(old_user1).fetch
    end

    def user2
      User.new(old_user2).fetch
    end

    def users
      [user1, user2]
    end
  end
end
