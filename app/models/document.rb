class Document < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_paper_trail
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: ->(a) { a[:path].blank? }, allow_destroy: true

  state_machine :state, initial: :wip do
    event :ask_for_review do
      transition wip: :in_review
    end

    event :rejected do
      transition in_review: :wip
      transition validate: :wip
    end

    event :validated do
      transition in_review: :validate
    end

    event :archived do
      transition validate: :archive
    end
  end

  has_many :tags

  validates :description,
            presence: true

  validates :title,
            presence: true
end
