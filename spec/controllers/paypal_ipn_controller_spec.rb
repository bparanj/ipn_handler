require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations

  context 'Invalid IPN' do
    before do
      @ipn = double("Paypal Service")
      @ipn.stub(:acknowledge => false)
      PaypalService.stub(:new) { @ipn }
      
      @logger = mock(:info => nil)
      controller.stub!(:paypal_logger) { @logger }
    end

    specify "IPN Listener accepts HTTP post from PayPal. The return http status code must be 204" do
      post 'notify', {}

      response.response_code.should == 204
    end

    specify "View should not be rendered for the Paypal IPN callback" do    
      post 'notify', {}
      response.body.should be_blank
    end

    specify 'If ipn is invalid, payment should not be processed' do
      @ipn.should_not_receive(:process_payment)

      post 'notify', {}
    end

    specify 'If ipn is invalid, log the message for manual intervention' do
      @logger.should_receive(:info)

      post 'notify', {}
    end
  end

  context 'Valid IPN' do
    before do
      @ipn = double("Paypal Service")
      @ipn.stub(:acknowledge => true )
      PaypalService.stub(:new) { @ipn }
    end
    
    specify 'Verify that the message came from PayPal. If so, payment should be processed' do
      @ipn.stub(:handle_new_transaction)

      @ipn.should_receive(:process_payment)

      post 'notify', {}
    end

    specify 'If the payment is new, handle the new payment' do
      @ipn.stub(:process_payment)

      @ipn.should_receive(:handle_new_transaction)
      post 'notify', {}
    end
    
  end
end
