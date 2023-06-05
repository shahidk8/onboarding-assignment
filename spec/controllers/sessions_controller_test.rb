require "rails_helper"

RSpec.describe SessionsController do 
  describe 'GET new' do 
    let(:session) { create :session }
    it 'assign nil session' do 
      get :new
      expect(assigns(:session)).to eq(nil)
    end
  end
end
