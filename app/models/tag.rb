class Tag < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_and_belongs_to_many :document

  validates :title,
            presence: true
end
