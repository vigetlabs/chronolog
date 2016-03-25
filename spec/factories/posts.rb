FactoryGirl.define do
  factory :post do
    title          'Such Post'
    body           'Oh wow such post body.'
    author         factory: :user
    published_date 1.week.ago
  end
end
