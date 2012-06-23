require 'spec_helper'

describe PaypalIpnController do
  include ActiveMerchant::Billing::Integrations

  specify "Step 1 : IPN Listener should wait for an HTTP post from PayPal" do
    post 'notify', {}
    response.body.should be_blank
  end

  specify 'Step 2 : Read post from Paypal' do
  	request.stub!(:raw_post).and_return(http_raw_data)

	post 'notify', {}
	# notify should be local variable. It has been made available to view to test step 2
	assigns[:notify].should_not be_nil
  end

  specify 'Step 3 : Post back to PayPal system to validate'  do
	request.stub!(:raw_post).and_return(http_raw_data)
	Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')

	post 'notify', {}

	assigns[:verify].should be_true
  end

  specify 'Step 4 : If the response is VERIFIED check that the payment status is Completed' do
	request.stub!(:raw_post).and_return(http_raw_data)
	Paypal::Notification.any_instance.stub(:ssl_post).and_return('VERIFIED')

	post 'notify', {}
	assigns[:notify].status.should == 'Completed'    
  end

  specify "View should not be rendered for the Paypal IPN callback" do
    post 'notify', {}
    response.body.should be_blank
  end

  private

  def http_raw_data
    "mc_gross=500.00&address_status=confirmed&payer_id=EVMXCLDZJV77Q&tax=0.00&address_street=164+Waverley+Street&payment_date=15%3A23%3A54+Apr+15%2C+2005+PDT&payment_status=Completed&address_zip=K2P0V6&first_name=Tobias&mc_fee=15.05&address_country_code=CA&address_name=Tobias+Luetke&notify_version=1.7&custom=&payer_status=unverified&business=tobi%40leetsoft.com&address_country=Canada&address_city=Ottawa&quantity=1&payer_email=tobi%40snowdevil.ca&verify_sign=AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP&txn_id=6G996328CK404320L&payment_type=instant&last_name=Luetke&address_state=Ontario&receiver_email=tobi%40leetsoft.com&payment_fee=&receiver_id=UQ8PDYXJZQD9Y&txn_type=web_accept&item_name=Store+Purchase&mc_currency=CAD&item_number=&test_ipn=1&payment_gross=&shipping=0.00"
  end 

end