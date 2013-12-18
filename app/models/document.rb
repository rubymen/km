class Document < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_paper_trail

  validates :description,
            presence: true

  validates :title,
            presence: true
end
