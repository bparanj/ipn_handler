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
      n.stub(:payer_email) {  'big@spender.com' }

      @paypal_service = PaypalService.new(n)

      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end

    specify 'Order should be fulfilled if all checks pass'  do
      Payment.stub(:previously_processed?) { false }
      Payment.stub(:transaction_has_correct_amount?) { true }
      Account.stub(:spoofed_receiver_email?) { false }

      Order.should_receive(:mark_ready_for_fulfillment)

      @paypal_service.process_payment
    end

    specify 'Order should not be fulfilled if the receiver_email from paypal does not match primary paypal email'  do
      Payment.stub(:previously_processed?) { false }
      Payment.stub(:transaction_has_correct_amount?) { true }
      Account.stub(:spoofed_receiver_email?) { true }

      Order.should_not_receive(:mark_ready_for_fulfillment)

      @paypal_service.process_payment
    end    

    specify 'Order should not be fulfilled if the price has been changed by a malicious third party.'  do
      Payment.stub(:previously_processed?) { false }
      Account.stub(:spoofed_receiver_email?) { false }
      Payment.stub(:transaction_has_correct_amount?) { false }
      
      Order.should_not_receive(:mark_ready_for_fulfillment)

      @paypal_service.process_payment
    end    
    
    specify 'Check that transaction_id has not been previously processed'  do
      Account.stub(:spoofed_receiver_email?) { true }

      Payment.should_receive(:previously_processed?)

      @paypal_service.process_payment      
    end
        
  end

  context 'Payment is new' do
    specify 'If the Transaction is new then Payment must be created to store transaction_id and other details' do
      paypal_service = PaypalService.new(Paypal::Notification.new(http_raw_data))
      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
      payment = Payment.stub(:new_transaction?) { true }
      # Mocking a third-party API is not a good idea. Here I am violating it because create method is stable enough
      # and I don't want to test the active record save functionality
      Payment.should_receive(:create)

      paypal_service.handle_new_transaction('NEW_TRANSACTION_ID')
    end  

  end
    
  context 'Payment is Incomplete' do
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

     @paypal_service_incomplete = PaypalService.new(n)
     
     Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end
    # This test was passing even though the interface was changed from fulfill to mark_ready_for_fulfillment in the order object
    # Confirm that the payment_status is Completed, since IPNs are also sent for other payment status updates, such as Pending or Failed.
    # PayPal sends IPN messages for pending and denied payments as well; do not ship until the payment has cleared.
    specify 'Order should not be fulfilled if payment_status is not Completed'  do
      Order.should_not_receive(:mark_ready_for_fulfillment)

      @paypal_service_incomplete.process_payment
    end
    
  end
end