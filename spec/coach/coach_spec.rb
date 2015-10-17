require 'rails_helper'

RSpec.describe 'CoachAPI', type: :model do

  context 'Users' do
    it 'returns list of all users' do
      expect { Coach::User.all }.to_not raise_error
    end

    it 'should find newuser1' do
      expect(Coach::User.find('newuser1')).to be_truthy
    end

    it 'can search for usernames' do
      results = Coach::User.all(search: 'newuser1')

      expect(results).to be_truthy
      expect(results.count).to be > 0
      expect(results.map(&:fetch)).to include Coach::User.find('newuser1')
    end

    it 'should have accessible partnerships' do
      user = Coach::User.all.first.fetch
      expect { user.partnerships }.to_not raise_error
    end

    it 'should have accessible subscriptions' do
      user = Coach::User.all.first.fetch
      expect { user.subscriptions }.to_not raise_error
    end

    it 'should return partnerships with correct type' do
      user = Coach::User.all.first.fetch
      expect(user.partnerships.first).to be_a Coach::Partnership
    end

    it 'should return subscription with correct type' do
      user = Coach::User.all.first.fetch
      expect(user.subscriptions.first).to be_a Coach::Subscription
    end

    it 'should equal the user of its subscription' do
      user = Coach::User.all.first.fetch
      expect(user.subscriptions.first.user).to eq user
    end

    it 'should equal one user of its partnership' do
      user = Coach::User.all.first.fetch
      partnership = user.partnerships.first

      expect(partnership.users).to include user
    end

  end

end
