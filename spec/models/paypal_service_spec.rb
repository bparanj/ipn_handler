require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalService do
  let(:paypal_service) do
    PaypalService.new(http_raw_data)
  end
  
  specify 'Payment status must be complete'  do 
    paypal_service.notify.should be_complete
  end
  
  specify 'Check that transaction id has not been previously processed' do
    already_processed = paypal_service.transaction_processed?

    already_processed.should be_false
  end
  
  specify 'Step 3 in IPN handler : Post back to PayPal system to validate' do
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
    # Could have writted paypal_service.notify.status.should == 'Completed'
    # From client perspective, only acknowledge value is important
    # It is also the implementation details of the ActiveMerchant plugin
    # The plugin tests that case and we would be testing the plugin unnecessarily.
    paypal_service.notify.acknowledge.should be_true
  end

  specify 'Step 3 in IPN handler negative case: Post back to PayPal system to validate' do
    Paypal::Notification.any_instance.stub(:ssl_post).and_return('INVALID')
    
    paypal_service.notify.acknowledge.should be_false
  end
  
  specify 'Check that payment amount and payment currency are correct' do
    paypal_service.check_payment.should be_true
  end
  
  specify 'Check that receiver_email is your buyer\'s Primary Paypal email' do    
    primary_paypal_email = paypal_service.primary_paypal_email?
    
    primary_paypal_email.should be_true
  end
  
end