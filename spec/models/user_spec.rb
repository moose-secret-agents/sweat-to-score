require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
    User.delete_all
    @user1 = Fabricate(:user, username: 'User1')
    @user2 = Fabricate(:user, username: 'User2')

    Partnership.delete_all
  end

  it 'can propose new partnership' do
    @partnership = @user1.propose_partnership @user2
    expect(@partnership.reload.status).to eq('proposed')
  end

  it 'can accept created partnership' do
    @partnership = @user1.propose_partnership @user2
    @user2.accept_partnership @user1

    expect(@partnership.reload.status).to eq('accepted')
  end

  it 'can refuse created partnership' do
    @partnership = @user1.propose_partnership @user2
    @user2.refuse_partnership @user1

    expect(@partnership.reload.status).to eq('refused')
  end

  it 'should have partner after accepting partnership' do
    @user1.propose_partnership @user2
    @user2.accept_partnership @user1

    expect(@user1.partners).to include(@user2)
    expect(@user2.partners).to include(@user1)
  end

  it 'should not create a partnership if one already exists and set status to accepted' do
    ps1 = @user1.propose_partnership @user2
    ps2 = @user2.propose_partnership @user1

    ps1.reload
    ps2.reload

    expect(ps1).to eq(ps2)
    expect(ps1.status).to eq('accepted')
  end

  it 'has list of created leagues' do
    expect {@user1.leagues}.to_not raise_error
  end

  it 'can create leagues' do
    expect {@user1.leagues.create(name: 'Hello', level: 2)}.to change{@user1.leagues.count}.by(1)
  end
end
