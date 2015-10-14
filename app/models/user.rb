class User < ActiveRecord::Base
  include Teamable

  has_many :partnerships
  has_many :leagues, foreign_key: 'owner_id'

  validates_presence_of :name, :email, :password
  # has_many :partners, through: :partnerships
  # has_many :partners, class_name: 'Partnership', foreign_key: 'user_id'
  # has_many :partners, class_name: 'Partnership'

  def partners
    Partnership.accepted.where(user: self).map(&:partner) | Partnership.accepted.where(partner: self).map(&:user)
  end

  def propose_partnership(partner)
    own_proposal = partnerships.find_by(user: self, partner: partner)
    his_proposal = partner.partnerships.find_by(user: partner, partner: self)

    if own_proposal
      return own_proposal
    elsif his_proposal
      accept_partnership partner
      return his_proposal
    else
      self.partnerships.create(partner: partner)
    end
  end

  def accept_partnership(from_user)
    proposal = from_user.partnerships.find_by(partner: self)
    proposal.accept
  end

  def refuse_partnership(from_user)
    proposal = from_user.partnerships.find_by(partner: self)
    proposal.refuse
  end
end
