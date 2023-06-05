require 'rails_helper'

RSpec.describe Document, type: :model do
  context 'when creating a document' do
    let(:document) { build :document }
    let(:document2) { create :document}
    it 'should be valid document' do
        document.valid? == true
    end

    it 'should have id nil' do 
      expect(document.id).to eq(nil)
    end
  end
end