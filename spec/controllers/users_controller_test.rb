require "rails_helper"

RSpec.describe UsersController do 
  describe 'GET index' do 
    let(:user) { create :user }
    it 'assigns @users' do 
      redirect_if_signed_in
      user = User.create
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end
end
