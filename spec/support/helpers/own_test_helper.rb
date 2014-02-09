module OwnTestHelper

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def add_beer(credentials)
    visit new_beer_path
    fill_in('beer_name', with:credentials[:beer_name])
    #click_button('Create Beer')
  end
end