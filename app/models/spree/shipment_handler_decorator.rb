module Spree
	ShipmentHandler.class_eval do 
		def perform
	      @shipment.inventory_units.each &:ship!
	      @shipment.process_order_payments if Spree::Config[:auto_capture_on_dispatch]
	      @shipment.touch :shipped_at
          update_order_shipment_state
          if !@shipment.has_gift_cards?
            send_shipped_email
          end
	    end
	end
end