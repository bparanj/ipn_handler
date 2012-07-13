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
  
  specify 'payer_email - Customer primary email address. Use this email to provide any credits. Length: 127 characters' do
    account = Account.new
    long_user_name = 'z' * 116
    account.primary_paypal_email = "#{long_user_name}@disney.com"
    account.save
    
    account.reload
    account.primary_paypal_email.should == "#{long_user_name}@disney.com"
  end
  
  specify 'primary_paypal_email cannot exceed 127 characters' do
    account = Account.new
    long_user_name = 'z' * 127
    account.primary_paypal_email = "#{long_user_name}@disney.com"

    account.save.should be_false
  end
  
end
