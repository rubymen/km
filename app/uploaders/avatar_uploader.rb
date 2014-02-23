# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/fallback/" + [version_name, "avatar_default.png"].compact.join('_')
  end

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
