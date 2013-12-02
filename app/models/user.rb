class User < ActiveRecord::Base
  devise  :confirmable,
          :database_authenticatable,
          :lockable,
          :recoverable,
          :rememberable,
          :timeoutable,
          :trackable

  validates :birthdate,
            presence: true

  validates :firstname,
            presence: true

  validates :lastname,
            presence: true
end
