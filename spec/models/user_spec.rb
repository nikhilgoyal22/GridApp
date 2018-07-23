require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }

  it 'should validate uniqueness of username' do
    user1 = User.create(username: 'u1')
    user2 = User.new(username: 'u1')
    user2.valid?
    expect(user2.errors[:username]).to include("has already been taken")
  end
end
