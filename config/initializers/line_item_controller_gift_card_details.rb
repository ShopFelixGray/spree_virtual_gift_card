Rails.application.config.to_prepare do
  Spree::Api::V1::LineItemsController.line_item_options += [gift_card_details: [:recipient_name, :recipient_email, :gift_message, :purchaser_name, :send_email_at]]
  Rails.application.config.spree.line_item_comparison_hooks << Spree::Order.gift_card_match
end
