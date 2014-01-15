class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :document

  validates :title,
            presence: true
end
