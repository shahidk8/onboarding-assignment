require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'assigns all users to @users' do
      users = create_list(:user, 1)
      get :index
      expect(assigns(:users)).to eq(users)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { user: { name: 'John', email: 'john@example.com', password: 'password' } } }

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'redirects to the root url' do
        post :create, params: valid_params
        expect(response).to redirect_to(root_url)
      end

      it 'sets the flash notice message' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Sucessfully signed up...')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: { name: 'John', email: 'invalid_email', password: 'password' } }
        }.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: { user: { name: 'John', email: 'invalid_email', password: 'password' } }
        expect(response).to render_template(:new)
      end

      it 'sets the flash notice message' do
        post :create, params: { user: { name: 'John', email: 'invalid_email', password: 'password' } }
        expect(flash[:notice]).to eq('Error signing up')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    it 'deletes the user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it 'sets the flash notice message' do
      delete :destroy, params: { id: user.id }
      expect(flash[:notice]).to eq('User Deleted')
    end

    it 'redirects to the users path' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'GET #edit' do
    let!(:user) { create(:user) }

    it 'assigns the requested user to @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end
  
  describe 'PATCH #update' do
  let!(:user) { create(:user) }
  let(:valid_params) { { user: { name: 'Updated Name' } } }

  context 'with valid parameters' do
    it 'updates the user' do
      patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
      user.reload
      expect(user.name).to eq('Updated Name')
    end

    it 'redirects to the user show page' do
      patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
      expect(response).to redirect_to(user)
    end

    it 'sets the flash notice message' do
      patch :update, params: { id: user.id, user: { name: 'Updated Name' } }
      expect(flash[:notice]).to eq('Successfully updated')
    end
  end

  context 'with invalid parameters' do
    it 'does not update the user' do
      patch :update, params: { id: user.id, user: { name: '' } }
      user.reload
      expect(user.name).not_to eq('')
    end

    it 'renders the edit template' do
      patch :update, params: { id: user.id, user: { name: '' } }
      expect(response).to render_template(:edit)
    end

    it 'sets the flash notice message' do
      patch :update, params: { id: user.id, user: { name: '' } }
      expect(flash[:notice]).to eq('Error while updating')
    end
  end
end
  
    context "with invalid params" do
      it "does not create a new user and returns unprocessable entity status code" do
        post :create, params: { user: { name: "", email: "", password: ""} }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

end



# require 'rails_helper'

# RSpec.describe UsersController, type: :controller do
#   let(:user) { create(:user) }
#   let(:valid_params) { { name: "John Doe", email: "john@example.com", password: "password@123", role: "admin" } }

#   describe "GET #index" do
#     it "returns a success response" do
#       get :index
#       expect(response).to be_successful
#     end
#   end

#   describe "POST #create" do
#     context "with valid params" do
#       it "creates a new user" do
#         expect {
#           post :create, params: { user: valid_params }
#         }.to change(User, :count).by(1)
#       end

#       it "assigns the newly created user to the current session" do
#         post :create, params: { user: valid_params }
#         expect(session[:user_id]).to eq(assigns(:user).id)
#       end

#       it "redirects to the user's show page" do
#         post :create, params: { user: valid_params }
#         expect(response).to redirect_to(user_path(assigns(:user)))
#       end
#     end

#     context "with invalid params" do
#       it "does not create a new user and returns unprocessable entity status code" do
#         post :create, params: { user: { name: "", email: "", password: "", role: "" } }
#         expect(response).to have_http_status(:unprocessable_entity)
#       end
#     end
#   end

#   # Add tests for other actions (e.g., #create, #destroy, #edit, #update)
# end
