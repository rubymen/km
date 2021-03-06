class Document < ActiveRecord::Base
  extend FriendlyId

  is_impressionable

  friendly_id :title, use: :slugged

  has_paper_trail on: :update

  searchkick language: 'French', text_start: [:title]

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

  has_and_belongs_to_many :users, uniq: true
  has_many :attachments
  has_many :comments
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :attachments, reject_if: ->(a) { a[:path].blank? }, allow_destroy: true

  validates :description,
            presence: true

  validates :title,
            presence: true

  def search_data
    {
      content:      content,
      description:  description,
      tags:         tags.map(&:title),
      title:        title,
      total_visits: impressionist_count,
      updated_at:   updated_at
    }
  end

  def self.to_search(params)
    params[:elastic].delete_if { |k, v| v.blank? } if params[:elastic]

    custom_search = {
      fields: [:description, :title, :tags],
      highlight: { tag: "<span class='highlight'>" },
      misspellings: { distance: 2 },
      page: params[:page],
      partial: true,
      per_page: 10,
      order: {},
      where: {}
    }

    custom_search[:order].merge!({ title: :asc }) if params[:elastic].try(:[], :alphabetically).to_i == 1
    custom_search[:order].merge!({ total_visits: :desc }) if params[:elastic].try(:[], :most_popular).to_i == 1
    custom_search[:order].merge!({ updated_at: :desc }) if params[:elastic].try(:[], :most_recent).to_i == 1

    custom_search[:where].merge!({ updated_at: { lte: Time.now, gte: (Time.now - 1.week) } }) if params[:elastic].try(:[], :this_week).to_i == 1
    custom_search[:where].merge!({ updated_at: { lte: Time.now, gte: (Time.now.beginning_of_day) } }) if params[:elastic].try(:[], :today).to_i == 1

    self.search (params[:elastic].try(:[], :search) || '*'), custom_search
  end
end
