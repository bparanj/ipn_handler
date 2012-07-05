class PaypalService
  attr_reader :notify, :valid

  include ActiveMerchant::Billing::Integrations

  def initialize(notify)
    @notify = notify
  end

  def process_payment
    if @notify.complete?
      
      previously_processed = Payment.previously_processed?(@notify.transaction_id)
      unless previously_processed
        if Account.receiver_email_merchant_primary_paypal_email?(@notify.item_id, @notify.account)      	
          if Payment.transaction_has_correct_amount?(@notify, @notify.gross, @notify.currency)
            Order.ready_for_fulfillment(@notify.item_id)
          end
        end
      end
    end

  end

end

