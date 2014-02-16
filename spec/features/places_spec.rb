require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "shows all the beer places that are returned" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi"), Place.new(:name => "Gurulan salakapakka") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Gurulan salakapakka"
  end

  it "shows the correct message when beer places are not found" do
    BeermappingApi.stub(:places_in).with("surula").and_return(
        [ ]
    )
    visit places_path
    fill_in('city', with: 'surula')
    click_button "Search"

    expect(page).to have_content "No locations in surula"
  end
end