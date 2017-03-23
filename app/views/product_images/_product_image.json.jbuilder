json.extract! product_image, :id
json.image_url product_image.image_url(:medium, public: true)
json.url product_image_url(product_image, format: :json)