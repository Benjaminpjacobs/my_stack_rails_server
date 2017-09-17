FactoryGirl.define do
  factory :user do
    email
    name
    password '1a2s3d4f5g6h'
    password_confirmation '1a2s3d4f5g6h'
  end

  sequence :email do |n|
    "john#{n}@example.com"
  end

  sequence :name do |n|
    "john#{n}"
  end
end
