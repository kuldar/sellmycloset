########################
##  Shipping Targets  ##
########################

shipping_targets_data = ActiveSupport::JSON.decode(File.read('db/seeds/shipping_targets.json'))

shipping_targets_data.each do |target|
  if target['TYPE'] == "0"
    ShippingTarget.create!(
      name: target['NAME'],
      code: target['ZIP'],
      address: "#{target['A5_NAME']} #{target['A7_NAME']}",
      city: target['A2_NAME'],
      country: target['A0_NAME']
    )
  end
end