require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do

  context 'Payment is Complete' do
    before do
      n = Bogus.notification('name=mama')
      n.stub(:acknowledge) { true }
      n.stub(:complete?) { true }
      n.stub(:transaction_id) { "6G996328CK404320L" }
      n.stub(:notify_id) { '1234' }
      n.stub(:gross) { "500.00" }
      n.stub(:currency) { 'CAD' }
      n.stub(:account) {'tobi@leetsoft.com'}
      n.stub(:item_id) {  '89CVZ' }

      @paypal_service = PaypalService.new(n)

      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end

    specify 'Order should be fulfilled if all checks pass'  do
      Payment.stub(:previously_processed?) { false }
      Payment.stub(:transaction_has_correct_amount?) { true }
      Account.stub(:receiver_email_merchant_primary_paypal_email?) { true }

      Order.should_receive(:ready_for_fulfillment)

      @paypal_service.process_payment
    end
    
    specify 'Check that transaction_id has not been previously processed'  do
      Account.stub(:receiver_email_merchant_primary_paypal_email?) { false }

      Payment.should_receive(:previously_processed?)

      @paypal_service.process_payment      
    end
  end

  context 'Payment Incomplete' do
    before do
     n = Bogus.notification('name=mama')
     n.stub(:acknowledge) { true }
     n.stub(:complete?) { false }
     n.stub(:transaction_id) { "6G996328CK404320L" }
     n.stub(:notify_id) { '1234' }
     n.stub(:gross) { "500.00" }
     n.stub(:currency) { 'CAD' }
     n.stub(:account) {'tobi@leetsoft.com'}
     n.stub(:item_id) {  '89CVZ' }

     @paypal_service_incompelete = PaypalService.new(n)
     
     Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end
#  This test was passing even though the interface was changed from fulfill to ready_for_fulfillment in the order object
    specify 'Order should not be fulfilled if payment_status is not Completed'  do
      Order.should_not_receive(:ready_for_fulfillment)

      @paypal_service_incompelete.process_payment
    end
    # Confirm that the payment status is Completed.
    # PayPal sends IPN messages for pending and denied payments as well; do not ship until the payment has cleared.

    # specify 'Verify that you are the intended recipient of the IPN message by checking the email address in the message'

  end
end