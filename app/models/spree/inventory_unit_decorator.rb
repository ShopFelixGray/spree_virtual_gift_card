module Spree
    InventoryUnit.class_eval do
        
        has_one :gift_card, class_name: 'Spree::VirtualGiftCard'
    
    end
end
  