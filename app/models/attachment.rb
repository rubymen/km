class Attachment < ActiveRecord::Base
  mount_uploader :path, AttachmentsUploader

  belongs_to :document

  validates :path,
            presence: true
end
