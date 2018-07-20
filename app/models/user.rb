class User < ApplicationRecord
  has_many :grid_cells

  validates :username, uniqueness: true
end
