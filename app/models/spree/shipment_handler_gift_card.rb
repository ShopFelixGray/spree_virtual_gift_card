module Spree
    module ShipmentHandler
      class GiftCardHandler
  
      def initialize(shipment)
        @shipment = shipment
      end
  
      def perform
        @shipment.inventory_units.each &:ship!
        @shipment.process_order_payments
        @shipment.touch :shipped_at
        update_order_shipment_state
      end
  
      private
  
        def update_order_shipment_state
          order = @shipment.order
  
          new_state = OrderUpdater.new(order).update_shipment_state
          order.update_columns(
                               shipment_state: new_state,
                               updated_at: Time.current,
                               )
        end
    end
end