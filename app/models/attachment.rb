class Attachment < ActiveRecord::Base
  mount_uploader :path, AttachmentsUploader

  belongs_to :document
end
