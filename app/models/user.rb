class User < ActiveRecord::Base
  authenticates_with_sorcery!

  include Teamable

  has_many :partnerships
  has_many :leagues, foreign_key: 'owner_id', dependent: :destroy

  validates :username, uniqueness: true, presence: true

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes['password'] }
  validates :password, confirmation: true, if: -> { new_record? || changes['password'] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes['password'] }

  attr_accessor :email, :real_name, :coach_user

  delegate :real_name, :email, to: :coach_user, allow_nil: true
  alias_method :name, :real_name

  def coach_user
    return nil if new_record?
    @coach_user || (@coach_user = Coach::Client.new.users.find(self.username))
  end

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

  def remote_tokens
    self.coach_user.subscriptions.flat_map(&:entries).map(&:rounds).sum
  end
end
