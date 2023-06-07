FactoryBot.define do
  factory :user do
    name {Faker::Name.name_with_middle}
    email {Faker::Internet.email}
    password {Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)}
    user_name {Faker::Internet.username(specifier: 10)}
  end
end