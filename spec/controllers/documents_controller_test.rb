require "rails_helper"

RSpec.describe DocumentsController do 
  describe 'GET index' do 
    let(:document) { create :document }
    it 'all documents' do 
      document = Document.create
      get :index
      expect(assigns(:document)).to eq([document])
    end
  end
end
