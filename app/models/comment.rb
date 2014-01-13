class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  belongs_to :document

  has_many :comments, dependent: :destroy

  validates :content,
            presence: true

  validates :title,
            presence: true
end
