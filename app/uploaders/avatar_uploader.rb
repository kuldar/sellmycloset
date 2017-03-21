require 'image_processing/mini_magick'

class AvatarUploader < Shrine
  include ImageProcessing::MiniMagick

  # plugin :determine_mime_type
  # plugin :remove_attachment
  # plugin :store_dimensions
  plugin :validation_helpers
  # plugin :pretty_location
  plugin :processing
  plugin :versions

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io|
    size_500 = resize_to_fill!(io.download, 500, 500)
    size_100 = resize_to_fill!(io.download, 100, 100)

    {original: io, medium: size_500, thumb: size_100}
  end

end