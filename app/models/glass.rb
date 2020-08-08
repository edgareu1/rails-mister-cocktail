class Glass < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
