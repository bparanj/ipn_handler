class PaypalService
  attr_reader :notify

  include ActiveMerchant::Billing::Integrations

  def initialize(notify)
    @notify = notify
  end

  def process_payment
    return unless @notify.complete?

    return if  Payment.previously_processed?(@notify.transaction_id)  
    return if  Account.spoofed_receiver_email?(@notify.item_id, @notify.account)      	

    if Payment.transaction_has_correct_amount?(@notify.transaction_id, @notify.gross, @notify.currency)
      Order.mark_ready_for_fulfillment(@notify.item_id)
    end

  end
  # Store txn_id in database so that only unique transactions are processed
  # txn_id - The merchant’s original transaction identification number for 
  # the payment from the buyer, against which the case was registered.
  # mc_gross - Full amount of the customer's payment, before transaction 
  # fee is subtracted. Equivalent to payment_gross for USD payments. If this
  # amount is negative, it signifies a refund or reversal, and either of those payment 
  # statuses can be for the full or partial amount of the original transaction.
  def handle_new_transaction(transaction_id)
    if Payment.new_transaction?(transaction_id)
      Payment.create(transaction_id: transaction_id, 
                     amount: @notify.amount,
                     payment_method: 'Paypal',
                     description: @notify.params['item_name'],
                     payer_id: @notify.params['payer_id'],
                     status: @notify.status,
                     test: @notify.test?,
                     gross: @notify.gross, 
                     currency: @notify.currency,
                     payer_email: @notify.params['payer_email'])
    end
    # Added payer_id field that was not driven by test.
  end


end

