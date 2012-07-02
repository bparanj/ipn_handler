# Post the request to www.paypal.com or www.sandbox.paypal.com, depending on 
# whether you are going live or testing your listener in the Sandbox.
# TODO: Which file is using the PAYPAL_ACCOUNT constant? Why not move this config to production.rb and development.rb
if Rails.env.production?
  PAYPAL_ACCOUNT = 'your_account@yourbusiness.com'
else
  PAYPAL_ACCOUNT = 'fake-email@gmail.com'
  ActiveMerchant::Billing::Base.mode = :test
end