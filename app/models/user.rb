class User < ActiveRecord::Base
  has_many :teams, as: :teamable

  has_many :partnerships
  has_many :partners, through: :partnerships, foreign_key: 'user_id'
  # has_many :partners, class_name: 'Partnership', foreign_key: 'user_id'

  def propose_partnership(partner)
    proposal = partner.partnerships.find_by(partner: self)
    partner.accept_partnership(self) if proposal

    self.partnerships.create(partner: partner)
  end

  def accept_partnership(from_user)
    proposal = from_user.partnerships.find_by(partner: self)
    self.partnerships.create(partner: from_user) if proposal
  end
end
