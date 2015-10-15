require 'rails_helper'

RSpec.describe "teams/edit", type: :view do
  before(:each) do
    @team = assign(:team, Team.create!(
      :new => "MyString",
      :create => "MyString",
      :update => "MyString"
    ))
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", team_path(@team), "post" do

      assert_select "input#team_new[name=?]", "team[new]"

      assert_select "input#team_create[name=?]", "team[create]"

      assert_select "input#team_update[name=?]", "team[update]"
    end
  end
end
