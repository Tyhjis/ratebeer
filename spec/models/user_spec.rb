require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

  describe "with and improper password" do
    let(:user){ User.create username:"Pekka", password:"salainen", password_confirmation:"salainen"}

    it "is not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for describing one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beer_with_rating_and_certain_style(score, user, style)
    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings_and_certain_styles(*scores, user, style)
    scores.each do |score|
      create_beer_with_rating_and_certain_style(score, user, style)
    end
  end

  def create_beer_with_rating_and_certain_brewery(score, user, brewery_name)
    brewery = FactoryGirl.create(:brewery, name:brewery_name)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings_and_certain_breweries(*scores, user, brewery)
    scores.each do |score|
      create_beer_with_rating_and_certain_brewery(score, user, brewery)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for describing one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "with one rating returns the only style" do
      create_beer_with_rating_and_certain_style(20, user, "Pale ale")
      expect(user.favorite_style).to eq("Pale ale")
    end

    it "with multiple ratings returns the right average style" do
      create_beers_with_ratings_and_certain_styles(15, 15, 15, user, "Lager")
      create_beers_with_ratings_and_certain_styles(20, 20, 20, user, "IPA")
      expect(user.favorite_style).to eq("IPA")
    end

  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for describing one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "with one rating return the only brewery" do
      create_beer_with_rating_and_certain_brewery(20, user, "Koff")
      expect(user.favorite_brewery).to eq("Koff")
    end

    it "with multiple ratings return correct brewery" do
      create_beers_with_ratings_and_certain_breweries(10, 10, 10, user, "Koff")
      create_beers_with_ratings_and_certain_breweries(20, 20, 15, user, "Meikun kiljut")
      expect(user.favorite_brewery).to eq("Meikun kiljut")
    end
  end

end