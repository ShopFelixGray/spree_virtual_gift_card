Spree::Variant.class_eval do

    # Is this variant a gift card?
    def gift_card?
      product.gift_card?
    end
  
  end