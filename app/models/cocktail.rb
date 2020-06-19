class Cocktail < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :image_url, presence: true

  has_many :doses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, through: :doses
end
