class Cocktail < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :photo, presence: true

  belongs_to :category
  belongs_to :glass

  has_many :doses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, through: :doses

  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [:name],
    using: {
      tsearch: { prefix: true } # Search by incomplete words
    }

  def rating_average
    sum_ratings = reviews.reduce(0) { |sum, review| sum + review["rating"] }
    sum_ratings.fdiv(reviews.size)
  end

  # Rating points has a positive correlation with both the average rating and the number of reviews
  # While the first variable manifests a perfect correlation, the second shows a decreasing one
  def rating_points
    num_reviews = reviews.size
    rating_average.nan? ? 0 : (num_reviews * rating_average) / (num_reviews ** 0.8)
  end

  # Difficulty level based on the number of ingredients it has
  def difficulty
    case doses.size
    when 0 then "NA"
    when 1..3 then "Low"
    when 4..5 then "Medium"
    else "High"
    end
  end
end
