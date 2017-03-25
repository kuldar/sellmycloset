require 'image_processing/mini_magick'

class ProductImageUploader < Shrine
  include ImageProcessing::MiniMagick

  # plugin :determine_mime_type
  # plugin :remove_attachment
  plugin :store_dimensions
  plugin :validation_helpers
  # plugin :pretty_location
  plugin :processing
  plugin :versions

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io|
    original = io

    size_1200 = resize_to_fit!(original.download, 1200, 1200)
    size_800 =  resize_to_fit!(original.download, 800, 800)
    size_100 =  resize_to_fill!(original.download, 100, 100)

    {original: original, big: size_1200, medium: size_800, thumb: size_100}
  end

end