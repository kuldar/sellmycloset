class ProductImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  process resize_to_limit: [800, nil]

  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  # version :cover do
  #   process resize_and_crop: 800
  # end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private

    # def resize_and_crop(size)
    #   remove = ((image[:height] - image[:width])/2).round 
    #   image.shave("0x#{remove}") unless remove <= 0
    #   image.resize("#{size}xnil")
    #   image
    # end
end