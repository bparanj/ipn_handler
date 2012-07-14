require 'spec_helper'

describe Account do
  # Validate that the receiver’s email address, receiver_email is registered 
  # to you (the merchant) to make sure that this is not a spoof 
  specify 'Not a spoof : Check that receiver_email field from Paypal is merchant Primary Paypal Email' do
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
    # Account.spoofed_receiver_email?('X5FI29', receiver_email posted by Paypal)
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
  # "receiver_email - Primary email address of the payment recipient (merchant). If the payment is sent to a non-primary email address on your PayPal account, the receiver_email is still your primary email."
  specify 'primary_paypal_email cannot exceed 127 characters' do
    account = Account.new
    long_user_name = 'z' * 127
    account.primary_paypal_email = "#{long_user_name}@disney.com"

    account.save.should be_false
  end
  
  specify 'Email address or account ID of the payment recipient (merchant) is normalized to lowercase characters' do
    account = Account.new
    account.primary_paypal_email = "SOME_USER@example.com"
    account.save
    
    account.reload
    account.primary_paypal_email.should == "some_user@example.com"
  end
  
  specify 'Custom value as passed by you, the merchant cannot exceed 255 characters' do
    account = Account.new
    account.primary_paypal_email = "user@example.com"
    account.custom = "e" * 256
    
    account.save.should be_false
  end
  
  specify 'Custom value that is 255 characters is valid' do
    account = Account.new
    account.primary_paypal_email = "user@example.com"
    account.custom = "e" * 255
    
    account.save.should be_true  
  end
end
