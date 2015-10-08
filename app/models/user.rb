class User < ActiveRecord::Base
  has_many :teams, as: :teamable

  has_many :partnerships
  # has_many :partners, through: :partnerships
  # has_many :partners, class_name: 'Partnership', foreign_key: 'user_id'
  # has_many :partners, class_name: 'Partnership'

  def partners
    Partnership.accepted.where(user: self).map(&:partner) | Partnership.accepted.where(partner: self).map(&:user)
  end

  def propose_partnership(partner)
    self.partnerships.create(partner: partner)
  end

  def accept_partnership(from_user)
    proposal = from_user.partnerships.find_by(partner: self)
    proposal.accept
    proposal
  end

  def refuse_partnership(from_user)
    proposal = from_user.partnerships.find_by(partner: self)
    proposal.refuse
    proposal
  end
end
