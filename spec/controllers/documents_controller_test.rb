require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:user) { create(:user) }
  let(:document) { create(:document, user: user) }

  describe 'GET #index' do
    it 'renders the index template' do
      sign_in(user)
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns the user documents to @documents' do
      sign_in(user)
      get :index
      expect(assigns(:documents)).to eq(user.documents)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      sign_in(user)
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new Document to @document' do
      sign_in(user)
      get :new
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { document: { description: 'Test Document', doc: fixture_file_upload('document.pdf', 'application/pdf') } } }

      it 'creates a new document' do
      sign_in(user)
        expect {
          post :create, params: valid_params
        }.to change(Document, :count).by(1)
      end

      it 'redirects to the documents index' do
        sign_in(user)
        post :create, params: valid_params
        expect(response).to redirect_to(documents_path)
      end

      it 'sets a flash notice' do
        sign_in(user)        
        post :create, params: valid_params
        expect(flash[:notice]).to eq('File Uploaded Successfully!')
      end
    end

  end

  describe 'GET #show' do
    it 'sends the file to the user' do
      sign_in(user)

      get :show, params: { id: document.id }
      expect(response).to have_http_status(:success)
    end

    it 'redirects to the root url if the document does not exist' do
      sign_in(user)

      get :show, params: { id: 999 }
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'POST #update_column' do
    it 'updates the specified column' do
      sign_in(user)

      post :update_column, params: { id: document.id, column_name: 'shared' }
      expect(document.reload.shared).to be_truthy
    end
  end


  describe 'GET #shared_view' do
    it 'renders the shared view' do
      sign_in(user)

      get :shared_view
      expect(response).to render_template('shared/_shared')
    end

    it 'assigns the user documents to @documents' do
      sign_in(user)

      get :shared_view
      expect(assigns(:documents)).to eq(user.documents)
    end
  end
end
