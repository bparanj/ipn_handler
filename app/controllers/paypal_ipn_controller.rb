class PaypalIpnController < ApplicationController
  #skip security check because post comes from paypal. TODO: Test manually whether this is required or not
  skip_before_filter :verify_authenticity_token

  include ActiveMerchant::Billing::Integrations
  # TODO: Use a separate logger for IPN messages 
  def notify
    ipn = PaypalService.new(Paypal::Notification.new(request.raw_post))

    if ipn.acknowledge
      ipn.process_payment
    else
      logger.info("Failed to verify Paypal IPN notification : #{request.raw_post}")
    end

    render :text => '', :status => :no_content  
  end
end
