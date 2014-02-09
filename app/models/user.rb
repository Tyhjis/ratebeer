class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 }
  validates_format_of :password, :with => /(?=.*\d)(?=.*([A-Z]))/

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    get_average_by_style
  end

  def favorite_brewery
    return nil if ratings.empty?
    get_average_by_brewery
  end

  def get_average_by_style
    styles_count = { "Weizen" => 0, "Lager" => 0, "Pale ale" => 0, "IPA" => 0, "Porter" => 0 }
    styles_total_score = { "Weizen" => 0, "Lager" => 0, "Pale ale" => 0, "IPA" => 0, "Porter" => 0 }
    styles_avg = { "Weizen" => 0, "Lager" => 0, "Pale ale" => 0, "IPA" => 0, "Porter" => 0 }
    ratings.each do |r|
      styles_count[r.beer.style] = styles_count[r.beer.style] + 1
      styles_total_score[r.beer.style] += r.score
      styles_avg[r.beer.style] = styles_total_score[r.beer.style] / styles_count[r.beer.style]
    end
    best = styles_avg.sort_by { |style, score| score }.last
    best[0]
  end

  def get_average_by_brewery
    breweries_count = {}
    breweries_total_score = {}
    breweries_avg = {}

    ratings.each do |r|
      breweries_count[r.beer.brewery.name] = 0
      breweries_total_score[r.beer.brewery.name] = 0
      breweries_avg[r.beer.brewery.name] = 0
    end
    ratings.each do |r|
      breweries_count[r.beer.brewery.name] = breweries_count[r.beer.brewery.name] + 1
      breweries_total_score[r.beer.brewery.name] += r.score
      breweries_avg[r.beer.brewery.name] = breweries_total_score[r.beer.brewery.name] / breweries_count[r.beer.brewery.name]
    end
    best = breweries_avg.sort_by { |brewery, score| score }.last
    best[0]
  end

end
