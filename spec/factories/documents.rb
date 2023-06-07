FactoryBot.define do
  factory :document do
    name {Faker::File.file_name}
    description {Faker::Alphanumeric.alphanumeric(number: 10)}
    path {JSON.dump({:original_filename => "test.png", :temp => "/Users/shahid/Documents/store/test.png", :path => "/Users/shahid/Documents/store/test.png"})}
    user_id {1}
    shared {Faker::Boolean.boolean}
  end
end