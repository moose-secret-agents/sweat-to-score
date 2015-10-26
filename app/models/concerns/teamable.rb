module Teamable
  extend ActiveSupport::Concern

  included do
    has_many :teams, as: :teamable, dependent: :destroy
  end
end