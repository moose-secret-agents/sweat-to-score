require 'rails_helper'

RSpec.describe Partnership, type: :model do
  before(:all) do
    @user1 = Fabricate(:user, username: 'User1')
    @user2 = Fabricate(:user, username: 'User2')
  end

  before(:each) do
    Partnership.delete_all
    @partnership = Partnership.create(user: @user1, partner: @user2)
  end

  it 'should have status proposed when created' do
    expect(@partnership.status).to eq('proposed')
  end

  it 'should be proposed by user' do
    expect(@partnership.user).to be(@user1)
    expect(@partnership.partner).to be(@user2)
  end

  it 'should change its status when accepted' do
    @partnership.accept
    expect(@partnership.status).to eq('accepted')
  end

  it 'should change its status when refused' do
    @partnership.refuse
    expect(@partnership.status).to eq('refused')
  end
end
