class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :avatar, AvatarUploader

  devise  :database_authenticatable,
          :lockable,
          :recoverable,
          :rememberable,
          :timeoutable,
          :trackable

  validates :email,
            presence: true,
            uniqueness: true

  validates :firstname,
            presence: true

  validates :lastname,
            presence: true

  validates :password,
            presence: true,
            on: :create

  validates :password_confirmation,
            presence: true

  validates_date :birthdate,
                 allow_blank: true

  def name
    "#{firstname} #{lastname}"
  end
end
