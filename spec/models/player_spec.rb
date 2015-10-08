require 'rails_helper'

RSpec.describe Player, type: :model do

  let(:player) { Player.create(name: 'Teamless', talent: 70) }

  it 'should have a name' do
    expect(player.name).to eq('Teamless')
  end

  it 'should have a talent property range from 0 to 100' do
    expect(player.talent).to be_between(0, 100)
  end

  it 'should belong to a Team' do
    expect(player.team).to be_nil
  end
end
