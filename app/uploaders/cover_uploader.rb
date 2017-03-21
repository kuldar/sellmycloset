require 'image_processing/mini_magick'

class CoverUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :validation_helpers
  plugin :processing
  plugin :versions

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io|
    original = io
    size_800 =  resize_to_fit!(original.download, 800, 800)

    {original: original, medium: size_800}
  end

end