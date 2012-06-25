class PaypalService
  attr_reader :notify, :valid

  include ActiveMerchant::Billing::Integrations

  def initialize(data)
  	@notify = Paypal::Notification.new(data)
	@valid = @notify.acknowledge
  end

  def self.process_payment
    # check the $payment_status=Completed
    # check that $txn_id has not been previously processed
    # check that $receiver_email is your Primary PayPal email
    # check that $payment_amount/$payment_currency are correct
    # process payment
  end
  # All the methods below must be made private
  # Delegate the implementation to the PaymentNotification ActiveRecord object.
  # Test PaymentNotification methods. Move the tests in PaypalService object to PaymentNotification.
  def transaction_processed?
  	 #  Check the database if notify.transaction_id has been processed 
  	 # or not by hitting the db
  	false
  end

  def primary_paypal_email?
  	# Check that the notify.account is the your primary paypal email
  	# by hitting the db
  	# your could mean either the buyer or the seller. I don't know yet.
  	true
  end

  def check_payment
  	# Check notify.gross and notify.currency are correct 
  	# for this product by hitting the db
  	true
  end
end