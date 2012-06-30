require 'spec_helper'

describe Account do
  specify 'Check that receiver_email field from Paypal is merchant Primary Paypal Email' do
    account = Account.new
    account.custom = 'X5FI29'
    account.primary_paypal_email = 'bugs@disney.com'
    account.save
    
    result = Account.receiver_email_merchant_primary_paypal_email?('X5FI29','bugs@disney.com')
    result.should be_true
  end
end
