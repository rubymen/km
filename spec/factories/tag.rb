require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :tag do
    title { Forgery(:basic).text }
  end
end
