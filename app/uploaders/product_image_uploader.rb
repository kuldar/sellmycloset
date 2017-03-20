class ProductImageUploader < Shrine
  # include ImageProcessing::MiniMagick

  plugin :processing
  plugin :versions
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io, context|
    medium = resize_to_limit!(io.download, 500, 500)
    {original: io, medium: medium}
  end

end

# class ProductImageUploader < CarrierWave::Uploader::Base
#   include CarrierWave::MiniMagick
  
#   process resize_to_limit: [800, nil]

#   if Rails.env.production? || Rails.env.staging?
#     storage :fog
#   else
#     storage :file
#   end
  
#   # Override the directory where uploaded files will be stored.
#   # This is a sensible default for uploaders that are meant to be mounted:
#   def store_dir
#     "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
#   end

#   # Add a white list of extensions which are allowed to be uploaded.
#   def extension_white_list
#     %w(jpg jpeg gif png)
#   end
# end