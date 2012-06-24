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
end