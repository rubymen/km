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
    'administrator'   => { number: false },
    'alphabetically'  => { number: false },
    'contributor'     => { number: false },
    'member'          => { number: false },
  }

  mapping do
    indexes :created_at,  type: :date
    indexes :email,       type: :string
    indexes :firstname,   type: :string
    indexes :lastname,    type: :string
    indexes :phone,       type: :string
    indexes :street,      type: :string
    indexes :town,        type: :string
    indexes :type,        type: :string
  end

  def to_indexed_json
    {
      email:      self.email,
      firstname:  self.firstname,
      lastname:   self.lastname,
      phone:      self.phone,
      street:     self.street,
      town:       self.town,
      type:       self.type
    }.to_json

  end

  has_many :users

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

  validates :phone,
            format: { with: /((\+|00)33\s?|0)[679](\s?\d{2}){4}/ },
            allow_blank: true

  validates_date :birthdate,
                 allow_blank: true

  def name
    "#{firstname} #{lastname}"
  end

  def self.search(params)
    facet_names = FACET_MAPPING.keys

    tire.search do
      if params[:elastic]
        query_string = ''
        search = params['elastic']['search']

        facet_names.each do |facet_name|
          if params['elastic'][facet_name].to_i == 1
            if facet_name == 'alphabetically'
              sort { by :firstname }
            end
            if facet_name == 'administrator'
              query_string = '*Admin* OR '
            end
            if facet_name == 'contributor'
              query_string += '*Contributor* OR '
            end
            if facet_name == 'member'
              query_string += '*Member* OR '
            end
          end
        end

        if query_string.blank?
          query { string "*#{search}*" }
        else
          query { string "*#{search}*" + " AND " + "(#{query_string[0..-5]}*)"}
        end

        highlight :firstname, :lastname, options: { tag: "<span class='highlight'>" }
      end
    end
  end
end
