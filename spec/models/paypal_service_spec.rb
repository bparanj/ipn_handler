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
      order = double("Order")
      Order.stub(:find) { order }
      Payment.stub(:previously_processed?) { false }

      order.should_receive(:fulfill)

      @paypal_service.process_payment
    end
    
    specify 'Check that transaction_id has not been previously processed'  do
      order = stub('Order').as_null_object
      Order.stub(:find) { order }
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

    specify 'Order should not be fulfilled if payment_status is not Completed'  do
      order = double("Order")
      Order.stub(:find) { order }

      order.should_not_receive(:fulfill)

      @paypal_service_incompelete.process_payment
    end

  end
end