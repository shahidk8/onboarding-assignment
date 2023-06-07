require 'rails_helper'
require 'shoulda-matchers'

RSpec.describe Document, type: :model do

  it "requires the presence of name" do
    expect(Document.new).not_to be_valid
  end

  it "requires the presence of description" do
    expect(Document.new(description: nil)).not_to be_valid
  end

  it "requires the presence of path" do
    expect(Document.new(path: nil)).not_to be_valid
  end

  it "requires the presence of user_id" do
    expect(Document.new(user_id: nil)).not_to be_valid
  end

  it "requires the path to be unique" do
    expect(Document.new()).not_to be_valid
  end

end