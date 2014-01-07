class Document < ActiveRecord::Base
  extend FriendlyId
  include Tire::Model::Search
  include Tire::Model::Callbacks

  friendly_id :title, use: :slugged

  has_paper_trail

  mapping do
    indexes :content,     type: :string
    indexes :description, type: :string
    indexes :title,       type: :string
  end

  def to_indexed_json
    {
      content: self.content,
      description: self.description,
      title: self.title,
    }.to_json
  end

  validates :description,
            presence: true

  validates :title,
            presence: true
end
