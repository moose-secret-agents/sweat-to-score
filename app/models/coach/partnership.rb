module Coach
  class Partnership < Coach::Entity
    property :userconfirmed1
    property :userconfirmed2
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
  end
end
