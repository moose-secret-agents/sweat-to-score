class Partnership < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :partner, class_name: 'User', foreign_key: 'partner_id'
end
