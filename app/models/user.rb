class User < ApplicationRecord
  has_many :grid_cells

  validates_presence_of :username
  validates :username, uniqueness: true
end
