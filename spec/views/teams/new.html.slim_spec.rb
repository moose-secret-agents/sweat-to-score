require 'rails_helper'

RSpec.describe "teams/new", type: :view do
  before(:each) do
    assign(:team, Team.new(
      :new => "MyString",
      :create => "MyString",
      :update => "MyString"
    ))
  end

  it "renders new team form" do
    render

    assert_select "form[action=?][method=?]", teams_path, "post" do

      assert_select "input#team_new[name=?]", "team[new]"

      assert_select "input#team_create[name=?]", "team[create]"

      assert_select "input#team_update[name=?]", "team[update]"
    end
  end
end
