class Cocktail < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :photo, presence: true

  has_many :doses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, through: :doses

  has_one_attached :photo

  def rating_average
    count = 0
    sum = 0
    reviews.each do |review|
      sum += review["rating"]
      count += 1
    end
    sum.to_f / count
  end

  # Relevance points has a positive relationship with both the average rating and the number of
  # reviews; the number of reviews has a decreasing relevance
  def relevance_points
    size = reviews.size
    rating_average.nan? ? 0 : (size * rating_average) / (size ** 0.67)
  end
end
