class Account < ActiveRecord::Base
  attr_accessible :primary_paypal_email

  validates_length_of :primary_paypal_email, :maximum => 127
  validates_length_of :custom, :maximum => 255
  
  before_save :normalize_primary_paypal_email
  
  # Validate that the receiver’s email address is registered to you.
  # This check provides additional protection against fraud.
  # receiver_email_merchant_primary_paypal_email
  def self.spoofed_receiver_email?(custom, email)
    account = find_by_custom(custom)
    account.primary_paypal_email != email
  end
  
  def normalize_primary_paypal_email
    self.primary_paypal_email.downcase!
  end
end
