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

  # All the methods below must be made private
  # Delegate the implementation to the PaymentNotification ActiveRecord object.
  # Test PaymentNotification methods. Move the tests in PaypalService object to PaymentNotification.

  # def primary_paypal_email?
  # 	# receiver_email - Primary email address of the payment recipient (merchant)
  # 	# Check that the notify.account is the your primary paypal email
  # 	# by hitting the db
  # 	# TODO: Item Id is the id that keys into the record of all fields that 
  # 	# gets saved in the database for IPN lookup using pass through custom variable
  # 	# Should the custom field be stored in account ? I don't know yet.
  # 	account = Account.find_by_custom(@notify.item_id)
  # 	account.primary_paypal_email == @notify.account
  # end

  # def check_payment
  # 	payment = Payment.find_by_transaction_id(notify.transaction_id)
  # 	payment.has_correct_amount?(notify.gross, notify.currency)
  # end
end