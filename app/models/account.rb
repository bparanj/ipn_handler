class Account < ActiveRecord::Base
  attr_accessible :primary_paypal_email

  # Validate that the receiver’s email address is registered to you.
  # This check provides additional protection against fraud.
  def self.receiver_email_merchant_primary_paypal_email?(custom, email)
    account = find_by_custom(custom)
    account.primary_paypal_email == email
  end
end
