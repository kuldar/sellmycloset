json.extract! product_image, :id, :created_at, :updated_at
json.image_url product_image.image.url
json.url product_product_image_url(@product, product_image, format: :json)