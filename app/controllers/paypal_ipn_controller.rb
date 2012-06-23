class PaypalIpnController < ApplicationController
  #skip security check because post comes from paypal
  skip_before_filter :verify_authenticity_token

  include ActiveMerchant::Billing::Integrations

  def notify
	@notify = Paypal::Notification.new(request.raw_post)
	@verify = @notify.acknowledge

  	render :nothing => true 
  end
end
