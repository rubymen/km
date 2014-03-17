class Comment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :document
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :content,
            presence: true

  def readable?
    !private?
  end
end
