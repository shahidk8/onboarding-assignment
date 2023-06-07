require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'sets the user_id in the session' do
        post :create, params: { session: { email: user.email, password: user.password, user_name: user.user_name } }
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to the root url' do
        post :create, params: { session: { email: user.email, password: user.password, user_name: user.user_name } }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid credentials' do
      it 'sets the flash notice' do
        post :create, params: { session: { email: 'invalid@example.com', password: 'password' } }
        expect(flash[:notice]).to eq('Incorrect Credentials')
      end

      it 'redirects to the login url' do
        post :create, params: { session: { email: 'invalid@example.com', password: 'password' } }
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'clears the user_id from the session' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the root url' do
      delete :destroy
      expect(response).to redirect_to(root_url)
    end
  end
end
