require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations

  before do
    @ipn = double("Paypal Service")
    @ipn.stub(:valid => false)
    PaypalService.stub(:new) { @ipn }
  end

  specify "Step 1 : IPN Listener should wait for an HTTP post from PayPal" do
    post 'notify', {}

    response.body.should be_blank
  end

  specify 'Step 2 : If ipn is valid, payment should be processed' do
    @ipn.stub(:valid => true )
    @ipn.should_receive(:process_payment)

    post 'notify', {}
  end

  specify 'Step 2 negative condition. If ipn is invalid, payment should not be processed' do
    @ipn.should_not_receive(:process_payment)

    post 'notify', {}
  end

  specify 'Step 2 negative condition. If ipn is invalid, log the message for manual intervention' do
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
