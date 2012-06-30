class PaypalService
  attr_reader :notify, :valid

  include ActiveMerchant::Billing::Integrations

  def initialize(notify)
    @notify = notify
    @valid = @notify.acknowledge
  end

  def process_payment
    # 1. check the $payment_status=Completed
    if @notify.complete?
      # TODO: Use the item id to find the order id that is combined 
      #  with other pass through variables.
      # 2. check that $txn_id has not been previously processed
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