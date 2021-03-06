module Spree
    Order.class_eval do

        has_many :gift_cards, through: :line_items
  
        def gift_card_match(line_item, options)
          return true unless line_item.gift_card?
          return true unless options["gift_card_details"]
          line_item.gift_cards.any? do |gift_card|
            gc_detail_set = gift_card.details.stringify_keys.except("send_email_at").to_set
            options_set = options["gift_card_details"].except("send_email_at").to_set
            gc_detail_set.superset?(options_set)
          end
        end
  
        def finalize!
          all_adjustments.each{|a| a.close}
          
          # update payment and shipment(s) states, and save
          updater.update_payment_state
          shipments.each do |shipment|
            shipment.update!(self)
            shipment.finalize!
          end
          
          updater.update_shipment_state
          save!
          updater.run_hooks
          
          touch :completed_at
          
          deliver_order_confirmation_email unless confirmation_delivered?

          consider_risk

          inventory_units = self.inventory_units

          inventory_units.each do |inventory_unit|
            gift_cards.each do |gift_card|
              if inventory_unit.line_item == gift_card.line_item
                gift_card.make_redeemable!(purchaser: user, inventory_unit: inventory_unit)
              end
            end
          end

          shipments.each do |shipment|
            if shipment.has_gift_cards?
              shipment.ship
            end
          end

          send_gift_card_emails
        end
  
        def send_gift_card_emails
          gift_cards.each do |gift_card|
            if gift_card.send_email_at.nil? || gift_card.send_email_at <= DateTime.now
              gift_card.send_email
            end
          end
        end
    end
end