FactoryGirl.define do
  factory :organization do
    sequence(:name) { |i| "Corporation X#{i}" }
  end
end
