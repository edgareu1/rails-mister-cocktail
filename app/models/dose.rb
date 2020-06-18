class Dose < ApplicationRecord
  validates :description, presence: true
  validates_uniqueness_of :cocktail_id, scope: :ingredient_id

  belongs_to :cocktail
  belongs_to :ingredient
end
