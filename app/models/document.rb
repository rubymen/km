class Document < ActiveRecord::Base
  extend FriendlyId
  include Tire::Model::Search
  include Tire::Model::Callbacks

  friendly_id :title, use: :slugged

  has_paper_trail

  FACET_MAPPING = {
    'alphabetically'  => { number: false },
    'always'          => { number: false },
    'most_popular'    => { number: false },
    'most_recent'     => { number: true },
    'search'          => { number: false },
    'this_month'      => { number: false },
    'this_week'       => { number: false },
    'today'           => { number: false },
  }

  mapping do
    indexes :content,     type: :string
    indexes :description, type: :string
    indexes :title,       type: :string
    indexes :updated_at,  type: :date
  end

  def to_indexed_json
    {
      content: self.content,
      description: self.description,
      title: self.title,
      updated_at: self.updated_at,
    }.to_json
  end

  validates :description,
            presence: true

  validates :title,
            presence: true

  def self.search(params)
    facet_names = FACET_MAPPING.keys

    tire.search(page: params[:page], per_page: 10) do
      if params['elastic']
        search = params['elastic']['search']
        query { string "*#{search}*" }
        highlight :title, :description, options: { tag: "<span class='highlight'>" }

        facet_names.each do |facet_name|
          if params['elastic'][facet_name].to_i == 1
            if facet_name == 'alphabetically' then sort { by :title }
            elsif facet_name == 'most_popular' then # complete
            elsif facet_name == 'most_recent' then sort { by :updated_at }
            elsif facet_name == 'this_month' then filter :range, updated_at: { lte: Time.now, gte: (Time.now - 1.month) }
            elsif facet_name == 'this_week' then filter :range, updated_at: { lte: Time.now, gte: (Time.now - 1.week) }
            elsif facet_name == 'today' then filter :range, updated_at: { lte: Time.now.beginning_of_day, gte: (Time.now.end_of_day) }
            end
          end
        end
      end
    end
  end
end
