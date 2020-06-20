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

  def relevance_points
    if rating_average.nan?
      return 0
    else
      (reviews.size * rating_average) / ( reviews.size ** 0.5 )
    end
  end
end
