class Spree::Api::V1::GiftCardsController < Spree::Api::BaseController

  def send_emails
    Spree::VirtualGiftCard.where(send_email_at: Date.today, sent_at: nil, redeemable: true).find_each do |gift_card|
      gift_card.send_email
    end
    render status: 200, json: {}
  end

  def redeem
    redemption_code = Spree::RedemptionCodeGenerator.format_redemption_code_for_lookup(params[:redemption_code] || "")
    @gift_card = Spree::VirtualGiftCard.active_by_redemption_code(redemption_code)

    if !@gift_card
      render status: :not_found, json: redeem_fail_response
    elsif @gift_card.redeem(@current_api_user)
      render status: :created, json: {}
    else
      render status: 422, json: redeem_fail_response
    end
  end

  private

  def redeem_fail_response
   {
      error_message: "#{Spree.t('admin.gift_cards.errors.not_found')}. #{Spree.t('admin.gift_cards.errors.please_try_again')}"
   }
 end
end
