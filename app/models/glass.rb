class Glass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :cocktails
end
