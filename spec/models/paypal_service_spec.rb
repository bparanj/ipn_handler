require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do

  context 'Payment is Complete' do
    before do
      notification = Bogus.notification('name=mama')
      notification.stub(:acknowledge) { true }
      notification.stub(:complete?) { true }
      notification.stub(:transaction_id) { "6G996328CK404320L" }
      notification.stub(:notify_id) { '1234' }
      notification.stub(:gross) { "500.00" }
      notification.stub(:currency) { 'CAD' }
      notification.stub(:account) {'tobi@leetsoft.com'}
      notification.stub(:item_id) {  '89CVZ' }

      @paypal_service = PaypalService.new(notification)
      # p @paypal_service
      # Paypal::Notification.any_instance.stub(:acknowledge).and_return(true)
      Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end
    
    specify 'Payment status must be complete', :focus => true do 
      @paypal_service.notify.should be_complete
    end

    specify 'Check that the transaction is not already processed, identified by the transaction ID', :focus => true do
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.processed = false
      payment.save

      already_processed = @paypal_service.transaction_processed?

      already_processed.should be_false
    end

    specify 'Step 3 in IPN handler : Post back to PayPal system to validate', :focus => true do
      # Could have writted paypal_service.notify.status.should == 'Completed'
      # From client perspective, only acknowledge value is important
      # It is also the implementation details of the ActiveMerchant plugin
      # The plugin tests that case and we would be testing the plugin unnecessarily.
      @paypal_service.notify.acknowledge.should be_true
    end

    specify 'Check that payment amount and payment currency are correct'  do
      Payment.delete_all
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.gross = 500.00
      payment.currency = 'CAD'
      payment.save

      @paypal_service.check_payment.should be_true
    end

    specify 'Check that receiver_email is your buyer\'s Primary Paypal email' do   
      account = Account.new 
      account.custom = "89CVZ"
      account.primary_paypal_email = 'tobi@leetsoft.com'
      account.save

      primary_paypal_email = @paypal_service.primary_paypal_email?

      primary_paypal_email.should be_true
    end
    # 1. 
    specify 'Order should be fulfilled if all checks pass'  do
      order = double("Order")
      Order.stub(:find) { order }
      Payment.stub(:previously_processed?) { false }

      order.should_receive(:fulfill)

      @paypal_service.process_payment
    end
    
    # 2.
    specify 'Check that transaction_id has not been previously processed'  do
      order = stub('Order').as_null_object
      Order.stub(:find) { order }
      Payment.should_receive(:previously_processed?)

      @paypal_service.process_payment      
    end

    xspecify 'Step 3 in IPN handler negative case: Post back to PayPal system to validate' do
      Paypal::Notification.any_instance.stub(:ssl_post).and_return('INVALID')

      @paypal_service.notify.acknowledge.should be_false
    end    
  end

  context 'Payment Incomplete' do
    before do
     @paypal_service2 = PaypalService.new(http_raw_data_incomplete)
     Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    end

    xspecify 'Order should not be fulfilled if payment_status is not Completed'  do
      order = double("Order")
      Order.stub(:find) { order }

      order.should_not_receive(:fulfill)

      @paypal_service2.process_payment
    end

  end
end