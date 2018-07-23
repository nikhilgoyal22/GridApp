require 'rails_helper'

RSpec.describe GridCell, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :row }
  it { should validate_presence_of :column }
  it { should validate_presence_of :color }
  it { should validate_uniqueness_of(:column).scoped_to(:row) }
end
