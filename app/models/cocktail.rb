class Cocktail < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :photo, presence: true

  has_many :doses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, through: :doses

  has_one_attached :photo

  def rating_average
    sum_ratings = reviews.reduce(0) { |sum, review| sum + review["rating"] }
    sum_ratings.fdiv(reviews.size)
  end

  # Relevance points has a positive relationship with both the average rating and the number of
  # reviews; the number of reviews has a decreasing relevance
  def relevance_points
    num_reviews = reviews.size
    rating_average.nan? ? 0 : (num_reviews * rating_average) / (num_reviews ** 0.67)
  end

  # Difficulty level based on the number of ingredients it has
  def difficulty
    case doses.size
    when 0 then "NA"
    when 1..3 then "Low"
    when 4..6 then "Medium"
    else "High"
    end
  end
end
