require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations

  specify "Step 1 : IPN Listener should wait for an HTTP post from PayPal" do
    post 'notify', {}
    response.body.should be_blank
  end

  specify 'Step 2 : Read post from Paypal' do
  	request.stub!(:raw_post).and_return(http_raw_data)
  	ipn = stub(:valid => true)
  	PaypalService.should_receive(:new).with(http_raw_data) { ipn }

	post 'notify', {}
  end

 specify 'Step 2 negative condition : Read post from Paypal. If ipn is invalid, log the message for manual intervention' do
 	logger = mock(:info => nil)
  	request.stub!(:raw_post).and_return(http_raw_data)
  	ipn = stub(:valid => false)
  	PaypalService.stub(:new).with(http_raw_data) { ipn }
  	controller.stub!(:logger) { logger }

    PaypalService.should_not_receive(:process_payment)
    logger.should_receive(:info)

	post 'notify', {}
  end

  specify 'Use the transaction ID to verify that the transaction has not already been processed' do
    request.stub!(:raw_post).and_return(http_raw_data)
    @notify = Paypal::Notification.new(http_raw_data)
    Paypal::Notification.stub(:new) { @notify }
	Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')
	PaypalService.should_receive(:process_payment)

	post 'notify', {}
  end

  specify "View should not be rendered for the Paypal IPN callback" do
    post 'notify', {}
    response.body.should be_blank
  end

end
