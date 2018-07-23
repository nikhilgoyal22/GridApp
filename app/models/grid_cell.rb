class GridCell < ApplicationRecord
  belongs_to :user

  validates_presence_of :row, :column, :color
  validates :column, uniqueness: { scope: :row }
end
