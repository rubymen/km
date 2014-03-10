require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :document do
    content { Forgery(:lorem_ipsum).words(300) }
    description { Forgery(:lorem_ipsum).words(99) }
    title { Forgery(:basic).text }
  end
end
