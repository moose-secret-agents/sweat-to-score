class Partnership < ActiveRecord::Base
  has_many :teams, as: :teamable

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :partner, class_name: 'User', foreign_key: 'partner_id'

  enum status: { proposed: 0, accepted: 1, refused: 2 }

  def accept
    accepted!
  end

  def refuse
    refused!
  end
end
