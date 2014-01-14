class User < ActiveRecord::Base
  extend FriendlyId
  include Tire::Model::Search
  include Tire::Model::Callbacks

  friendly_id :name, use: :slugged

  mount_uploader :avatar, AvatarUploader

  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :timeoutable,
          :trackable

  FACET_MAPPING = {
    'alphabetically' => { number: false },
    'most_recent' => { number: false },
    'most_popular' => { number: false },
    'always' => { number: false },
    'today' => { number: false },
    'this_month' => { number: false },
    'this_week' => { number: false },
  }

  mapping do
    indexes :email,     type: :string
    indexes :firstname, type: :string
    indexes :lastname,  type: :string
    indexes :phone,     type: :string
    indexes :street,    type: :string
    indexes :town,      type: :string
  end

  def to_indexed_json
    {
      email: self.email,
      firstname: self.firstname,
      lastname: self.lastname,
      phone: self.phone,
      street: self.street,
      town: self.town,
    }.to_json
  end

  validates :email,
            presence: true,
            uniqueness: true

  validates :firstname,
            presence: true

  validates :lastname,
            presence: true

  validates :password,
            presence: true,
            on: :create

  validates :password_confirmation,
            presence: true

  validates_date :birthdate,
                 allow_blank: true

  def name
    "#{firstname} #{lastname}"
  end

  def self.search(params)
    facet_names = FACET_MAPPING.keys

    tire.search(page: params[:page], per_page: 10) do
      if params['elastic']
        query do
          filtered do
            query do
              string '*'
            end

            facet_names.each do |facet_name|
              if params['elastic'][facet_name].to_i == 1
                # form_terms = params['elastic'][facet_name].delete_if(&:blank?)

                # if form_terms.any?
                #   filter(:terms, facet_name => params['elastic'][facet_name])
                # end
              end
            end
          end
        end
      end

      facet_names.each do |facet_name|
        facet(facet_name) do
          terms(facet_name, all_terms: true, order: :term, size: 99_999)
        end
      end

      sort { by :lastname, 'asc' }

      raise to_curl if params['raise']
    end
  end
end
