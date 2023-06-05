require 'rails_helper'

RSpec.describe User, type: :model do

  context 'when creating a user' do
    let(:user) { build :user }
    it 'should be valid user with all attributes' do
      expect(user.valid?).to eq(true)
    end
  end
end
