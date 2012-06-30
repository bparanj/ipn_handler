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
        order = Order.find(@notify.item_id)
        order.fulfill  			
      end
    end

    # check that $receiver_email is your Primary PayPal email
    # transaction_has_correct_amount?(transaction_id, gross, currency)
    # check that $payment_amount/$payment_currency are correct
    # process payment
  end

end