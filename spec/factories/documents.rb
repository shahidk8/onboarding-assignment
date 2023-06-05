FactoryBot.define do
  factory :document do
    name {Faker::File.file_name}
    description {Faker::Alphanumeric.alphanumeric(number: 10)}
    path {JSON.dump({path: "/Users/shahid/Documents/store/test.png", original_filename: "#{Faker::File.file_name}" })}
    user_id {1}
    shared {Faker::Boolean.boolean}
  end
end
