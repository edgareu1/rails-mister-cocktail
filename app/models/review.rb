class Review < ApplicationRecord
  belongs_to :cocktail

  validates :rating, presence: true, inclusion: 0..5, numericality: { only_integer: true }
  validates :content, presence: true
end
