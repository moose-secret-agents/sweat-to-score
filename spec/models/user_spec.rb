require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user1 = User.create(name: 'User1')
    @user2 = User.create(name: 'User2')
  end

  before(:each) do
    User.delete_all
    Partnership.delete_all
  end

  it 'can propose new partnership' do
    ps = @user1.propose_partnership @user2

    expect(ps.status).to eq('proposed')
  end

  it 'can accept created partnership' do
    ps = @user1.propose_partnership @user2
    @user2.accept_partnership @user1

    expect(ps.status).to eq('accepted')
  end

  it 'can refuse created partnership' do
    ps = @user1.propose_partnership @user2
    @user2.refuse_partnership @user1

    expect(ps.status).to eq('refused')
  end

  it 'should have partner after accepting partnership' do
    @user1.propose_partnership @user2
    @user2.accept_partnership @user1

    expect(@user1.partners).to include(@user2)
    expect(@user2.partners).to include(@user1)
  end
end
