require 'rails_helper'

# RSpec.describe User, type: :model do

#   context 'when creating a user' do
#     let(:user) { build :user }
#     it 'should be valid user with all attributes' do
#       expect(user.valid?).to eq(true)
#     end
#   end
# end


RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe 'associations' do
    it { should have_many(:documents) }
  end

  describe 'password encryption' do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'Password@123') }

    it 'encrypts the password' do
      expect(user.password_digest).not_to be_nil
    end

    it 'authenticates the user with correct password' do
      user.authenticate('password') == user
    end

    it 'does not authenticate the user with incorrect password' do
      expect(user.authenticate('wrong_password')).to eq(false)
    end
  end
end
