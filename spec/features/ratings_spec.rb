require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "Ratings page" do
    let!(:ratings1){ FactoryGirl.create :rating, score:10, beer:beer1, user:user }
    let!(:ratings2){ FactoryGirl.create :rating, score:15, beer:beer2, user:user }
    let!(:ratings3){ FactoryGirl.create :rating, score:20, beer:beer1, user:user }

    it "shows the correct amount of ratings" do
      visit ratings_path
      expect(page).to have_content 'Number of ratings: 3'
    end

    describe "User ratings" do
      let!(:user2) { FactoryGirl.create :user, username:'Erkki', password:'3rKk1', password_confirmation:'3rKk1' }
      let!(:ratings4){ FactoryGirl.create :rating, score:25, beer:beer1, user:user2 }

      it "shows only the users own ratings" do
        visit user_path(user2)
        expect(page).to have_content 'Has 1 rating'
        visit user_path(user)
        expect(page).to have_content 'Has 3 ratings'
      end
    end
  end
end