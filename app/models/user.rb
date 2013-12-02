class User < ActiveRecord::Base
  validates :birthdate,
            presence: true

  validates :firstname,
            presence: true

  validates :lastname,
            presence: true
end
