class User < ActiveRecord::Base
  validates :firstname,
            presence: true

  validates :lastname,
            presence: true

  validates :birthdate,
            presence: true
end
