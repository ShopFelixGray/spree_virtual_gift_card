Spree::StoreCreditCategory.find_or_create_by(name: 'Gift Card')
Spree::ShippingCategory.find_or_create_by(name: 'Gift Card')
Spree::ShippingMethod.find_or_create_by(admin_name: 'Gift Card Delivery') do |r|
    r.name = 'Gift Card Delivery'
    r.display_on = 'both'
    r.code = 'GC'
    r.calculator = Spree::Calculator::Shipping::FlatRate.create
    r.shipping_categories = [Spree::ShippingCategory.find_by(name: 'Gift Card')]
end
