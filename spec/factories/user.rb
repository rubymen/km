require 'factory_girl'
require 'forgery'

FactoryGirl.define do
  factory :user do
    birthdate { '1993-12-10' }
    country_code { Forgery(:address).country }
    email { Forgery(:internet).email_address }
    firstname { Forgery(:name).first_name }
    lastname { Forgery(:name).last_name }
    pwd = Forgery(:basic).password
    password { pwd }
    password_confirmation { pwd }
    phone { '+33606060606' }
    street { Forgery(:address).street_name }
    town { Forgery(:address).city }
    type { ['Users::Admin', 'Users::Member', 'Users::Contributor'].shuffle.first }
  end
end
