require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :comment do
    title { Forgery(:basic).text }
  end
end
