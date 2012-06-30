require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations


  specify "Step 1 : IPN Listener should wait for an HTTP post from PayPal" do
  	paypal_service = double("PaypalService")
  	paypal_service.stub(:valid => true)

    post 'notify', {}
    response.body.should be_blank
  end

  specify 'Step 2 negative condition. If ipn is invalid, payment should not be processed' do
  	paypal_service = double("PaypalService")
  	paypal_service.stub(:valid => false)  	

    PaypalService.should_not_receive(:process_payment)

    post 'notify', {}
  end

  specify 'Step 2 negative condition. If ipn is invalid, log the message for manual intervention' do
  	paypal_service = double("PaypalService")
  	paypal_service.stub(:valid => false)  	

    logger = mock(:info => nil)
    controller.stub!(:logger) { logger }

    logger.should_receive(:info)

    post 'notify', {}
  end
 
  specify "View should not be rendered for the Paypal IPN callback" do
    post 'notify', {}
    response.body.should be_blank
  end

end
