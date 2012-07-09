class PaypalService
  attr_reader :notify

  include ActiveMerchant::Billing::Integrations

  def initialize(notify)
    @notify = notify
  end

  def process_payment
    if @notify.complete?
      
      previously_processed = Payment.previously_processed?(@notify.transaction_id)
      unless previously_processed
        unless Account.spoofed_receiver_email?(@notify.item_id, @notify.account)      	
          if Payment.transaction_has_correct_amount?(@notify, @notify.gross, @notify.currency)
            Order.mark_ready_for_fulfillment(@notify.item_id)
          end
        end
      end
    end

  end

  def handle_new_transaction(transaction_id)
    if Payment.new_transaction?(transaction_id)
      Payment.create(transaction_id: transaction_id, 
                    amount: @notify.amount,
                    payment_method: 'Paypal',
                    description: @notify.params['item_name'],
                    status: @notify.status,
                    test: @notify.test?,
                    gross: @notify.gross, 
                    currency: @notify.currency)
    end
  end
end