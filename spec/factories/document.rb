require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :document do
    content { Forgery(:lorem_ipsum).words(300) }
    description { Forgery(:lorem_ipsum).words(99) }
    title { Forgery(:basic).text }
  end

  factory :document_with_user, :parent => :user do
    content { Forgery(:lorem_ipsum).words(300) }
    description { Forgery(:lorem_ipsum).words(99) }
    title { Forgery(:basic).text }
    users {[FactoryGirl.create(:user, type: 'Users::Admin')]}
  end
end
