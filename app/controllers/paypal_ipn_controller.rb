class PaypalIpnController < ApplicationController
  #skip security check because post comes from paypal
  skip_before_filter :verify_authenticity_token

  include ActiveMerchant::Billing::Integrations

  def notify
  	ipn = PaypalService.new(Paypal::Notification.new(request.raw_post))
	
	if ipn.valid
	  PaypalService.process_payment
	else
	  logger.info("Failed to verify Paypal IPN notification : #{request.raw_post}")
	end

  	render :nothing => true 
  end
end

 # log for manual investigation

