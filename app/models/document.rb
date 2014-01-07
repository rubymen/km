class Document < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_paper_trail

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

  validates :description,
            presence: true

  validates :title,
            presence: true
end
