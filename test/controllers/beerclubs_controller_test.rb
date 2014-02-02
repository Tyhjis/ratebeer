require 'test_helper'

class BeerclubsControllerTest < ActionController::TestCase
  setup do
    @beer_club = beerclubs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beer_clubs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beerclub" do
    assert_difference('Beerclub.count') do
      post :create, beer_club: { city: @beer_club.city, founded: @beer_club.founded, name: @beer_club.name }
    end

    assert_redirected_to beerclub_path(assigns(:beer_club))
  end

  test "should show beerclub" do
    get :show, id: @beer_club
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beer_club
    assert_response :success
  end

  test "should update beerclub" do
    patch :update, id: @beer_club, beer_club: { city: @beer_club.city, founded: @beer_club.founded, name: @beer_club.name }
    assert_redirected_to beerclub_path(assigns(:beer_club))
  end

  test "should destroy beerclub" do
    assert_difference('Beerclub.count', -1) do
      delete :destroy, id: @beer_club
    end

    assert_redirected_to beerclubs_path
  end
end
