require 'rails_helper'

RSpec.describe 'CoachAPI', type: :model do

  context 'Users' do
    it 'returns list of all users' do
      expect { Coachassist::User.all }.to_not raise_error
    end

    it 'should find newuser1' do
      expect(Coachassist::User.find('newuser1')).to be_truthy
    end

    it 'can search for usernames' do
      results = Coachassist::User.all(search: 'newuser1')

      expect(results).to be_truthy
      expect(results.count).to be > 0
      #expect(results.map(&:fetch)).to include Coachassist::User.find('newuser1')
    end

    it 'should have accessible partnerships' do
      user = Coachassist::User.all.first.fetch
      expect { user.partnerships }.to_not raise_error
    end

    it 'should have accessible subscriptions' do
      user = Coachassist::User.all.first.fetch
      expect { user.subscriptions }.to_not raise_error
    end

    it 'should return partnerships with correct type' do
      user = Coachassist::User.all.first.fetch
      expect(user.partnerships.first).to be_a Coachassist::Partnership
    end

    it 'should return subscription with correct type' do
      user = Coachassist::User.all.first.fetch
      expect(user.subscriptions.first).to be_a Coachassist::Subscription
    end

    it 'should equal the user of its subscription' do
      user = Coachassist::User.all.first.fetch
      expect(user.subscriptions.first.user).to eq user
    end

    it 'should equal one user of its partnership' do
      user = Coachassist::User.all.first.fetch
      partnership = user.partnerships.first

      expect(partnership.users).to include user
    end

  end

end
