require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  before(:each) do
    assign(:teams, [
      Team.create!(
        :new => "New",
        :create => "Create",
        :update => "Update"
      ),
      Team.create!(
        :new => "New",
        :create => "Create",
        :update => "Update"
      )
    ])
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "New".to_s, :count => 2
    assert_select "tr>td", :text => "Create".to_s, :count => 2
    assert_select "tr>td", :text => "Update".to_s, :count => 2
  end
end
