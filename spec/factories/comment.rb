require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :comment do
    content { Forgery(:basic).text }
  end
end
