# https://github.com/spree/spree/issues/1439
require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class VirtualGiftCardDelivery < ShippingCalculator
      preference :amount, :decimal, default: 0
      preference :currency, :string, default: ->{ Spree::Config[:currency] }

      def self.description
        Spree.t(:virtual_gift_card_delivery)
      end

      def compute_package(package=nil)
        self.preferred_amount
      end

      def available?(package)
        package.contents.all? { |content| content.variant.gift_card? }
      end
    end
  end
end