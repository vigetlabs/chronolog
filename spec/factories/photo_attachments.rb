FactoryGirl.define do
  factory :photo_attachment do
    record factory: :user
    photo
  end
end
