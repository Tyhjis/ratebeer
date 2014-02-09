require 'spec_helper'
include OwnTestHelper

describe "Beer" do
  let!(:brewery){ FactoryGirl.create :brewery, name:"Koff" }

  it "is added when given correct credentials" do
    add_beer(beer_name:'Kalia')
    expect {
    click_button('Create Beer')
    }.to change{Beer.count}.by(1)
    #puts page.html
  end

  it "shows error message when given incorrect credentials" do
    add_beer(beer_name:'')
    expect {
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)

    expect(page).to have_content 'error prohibited'
  end

end