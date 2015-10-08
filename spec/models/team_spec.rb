require 'rails_helper'

RSpec.describe Team, type: :model do

  let(:team) { Team.create(name: 'Transis', strength: 50) }

  it 'should have a team name' do
    expect(team.name).to eq('Transis')
  end

  it 'should have 11-25 players' do
    expect(team.players.count).to be_between(11, 25)
  end

end
