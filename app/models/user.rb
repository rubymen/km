class User < ActiveRecord::Base
  extend FriendlyId

  devise  :database_authenticatable,
          :recoverable,
          :rememberable,
          :timeoutable,
          :trackable

  friendly_id :name, use: :slugged

  mount_uploader :avatar, AvatarUploader

  searchkick language: 'French', text_start: [:lastname]

  has_and_belongs_to_many :documents

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

  def search_data
    {
      email:      email,
      firstname:  firstname,
      lastname:   lastname,
      name:       name,
      phone:      phone,
      street:     street,
      town:       town,
      type:       type,
      updated_at: updated_at
    }
  end

  def self.to_search(params)
    params[:elastic].delete_if { |k, v| v.blank? } if params[:elastic]

    custom_search = {
      fields: [:firstname, :lastname],
      highlight: { tag: "<span class='highlight'>" },
      misspellings: { distance: 2 },
      page: params[:page],
      partial: true,
      per_page: 10,
      order: {},
      where: {}
    }

    custom_search[:order].merge!({ name: :asc }) if params[:elastic].try(:[], :alphabetically).to_i == 1

    custom_search[:where].merge!({ type: ['Users::Admin'] }) if params[:elastic].try(:[], :administrator).to_i == 1
    custom_search[:where].merge!({ type: ['Users::Contributor'] }) if params[:elastic].try(:[], :contributor).to_i == 1
    custom_search[:where].merge!({ type: ['Users::Member'] }) if params[:elastic].try(:[], :member).to_i == 1

    self.search (params[:elastic].try(:[], :search) || '*'), custom_search
  end
end
