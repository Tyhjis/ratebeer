require 'spec_helper'

describe Beer do
  it "is in the db when created with correct parameters" do
    beer = Beer.create name:"bisse", style:"lager"

    expect(beer.name).to eq("bisse")
    expect(beer.style).to eq("lager")
    expect(Beer.count).to eq(1)
  end

  it "is not in the db when created without name" do
    beer = Beer.create style:"lager"
    expect(Beer.count).to eq(0)
  end

  it "is not in the db when created without style" do
    beer = Beer.create name:"kalia"
    expect(Beer.count).to eq(0)
  end

end