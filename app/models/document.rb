class Document < ActiveRecord::Base
  extend FriendlyId
  include Tire::Model::Search
  include Tire::Model::Callbacks

  friendly_id :title, use: :slugged

  has_paper_trail

  mapping do
    indexes :content,     type: :string
    indexes :description, type: :string
    indexes :nb_comments, type: :integer
    indexes :title,       type: :string
  end

  has_many :comments, dependent: :destroy

  validates :description,
            presence: true

  validates :title,
            presence: true

  def to_indexed_json
    {
      content: self.content,
      description: self.description,
      nb_comments: self.comments.count,
      title: self.title
    }.to_json
  end
end
