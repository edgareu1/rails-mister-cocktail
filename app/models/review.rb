class Review < ApplicationRecord
  validates :rating, presence: true, inclusion: 0..5, numericality: { only_integer: true }
  validates :content, presence: true

  belongs_to :cocktail
end
