class Account < ActiveRecord::Base
  attr_accessible :primary_paypal_email
  
  def self.receiver_email_merchant_primary_paypal_email?(custom, email)
    account = find_by_custom(custom)
    account.primary_paypal_email == email
  end
end
