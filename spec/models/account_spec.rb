require 'spec_helper'

describe Account do
  # Check email address to make sure that this is not a spoof
  specify 'Check that receiver_email field from Paypal is merchant Primary Paypal Email' do
    account = Account.new
    account.custom = 'X5FI29'
    account.primary_paypal_email = 'bugs@disney.com'
    account.save
    
    result = Account.spoofed_receiver_email?('X5FI29','bugs@disney.com')
    result.should be_false
  end

  specify 'Spoof Case : Check that receiver_email field from Paypal is merchant Primary Paypal Email' do
    account = Account.new
    account.custom = 'X5FI29'
    account.primary_paypal_email = 'bugs@disney.com'
    account.save
    
    result = Account.spoofed_receiver_email?('X5FI29','daffy@disney.com')
    result.should be_true
  end
  
  
end
