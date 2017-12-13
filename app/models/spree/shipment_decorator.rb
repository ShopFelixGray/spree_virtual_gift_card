module Spree
    Shipment.class_eval do

        def has_gift_cards?
            inventory_units.any? { |inventory_unit| inventory_unit.gift_card.present? }
        end

    end
end

