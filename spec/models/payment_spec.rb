require 'spec_helper'

describe Payment do
  context 'Payment amount checks' do
    specify 'Check gross and currency are correct' do
      payment = Payment.new
      payment.gross = 100.99
      payment.currency = 'CAD'

      result = payment.has_correct_amount?("100.99", 'CAD')
      result.should be_true 
    end

    specify 'Check gross and currency are correct : Same amount, different currency' do
      payment = Payment.new
      payment.gross = 100.99
      payment.currency = 'CAD'

      result = payment.has_correct_amount?("100.99", 'USD')
      result.should be_false
    end

    specify 'Check gross and currency are correct : Different amount, same currency' do
      payment = Payment.new
      payment.gross = 100.99
      payment.currency = 'CAD'

      result = payment.has_correct_amount?("200.99", 'CAD')
      result.should be_false
    end

    specify 'Check gross and currency are correct : Different amount, different currency' do
      payment = Payment.new
      payment.gross = 100.99
      payment.currency = 'CAD'

      result = payment.has_correct_amount?("200.99", 'USD')
      result.should be_false
    end  
    
    specify 'Check that given transaction has correct amount' do
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.gross = 100.00
      payment.currency = 'CAD'
      payment.save

      correct_amount = Payment.transaction_has_correct_amount?('6G996328CK404320L', '100.00',  'CAD')
      correct_amount.should be_true
    end
    
  end
  
  context 'Payment processing' do
    specify 'When the transaction status is complete, the transaction has been processed' do
      payment = Payment.new
      payment.transaction_id = 20
      payment.status = Payment::COMPLETE

      payment.should be_complete
    end

    specify 'Check that the transaction is not already processed, identified by the transaction ID' do
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.status = Payment::PENDING
      payment.save

      already_processed = Payment.previously_processed?('6G996328CK404320L')
      already_processed.should be_false
    end

    specify 'If the payment object is not found for the given transaction id, then it is not already processed.' do
      already_processed = Payment.previously_processed?('6G996328CK404320L')
      already_processed.should be_false
    end

    # Prevent duplicate transactions from being processed
    specify 'If the payment object is found for the given transaction id and the status is complete, then it is already processed.' do
      transaction_id = '6G996328CK404320L'
      payment = Payment.new
      payment.transaction_id = transaction_id
      payment.gross = 100.00
      payment.status = Payment::COMPLETE
      payment.currency = 'CAD'
      payment.save

      already_processed = Payment.previously_processed?(transaction_id)
      already_processed.should be_true
    end

    specify 'Create a new payment for a new transaction' do
      new_transaction = Payment.new_transaction?('6G996328CK404320L')
      new_transaction.should be_true
    end
    
    specify 'Payer id (unique customer id) should be saved. Max length 13 characters' do
      payment = Payment.new
      payment.transaction_id = '6G996328CK404320L'
      payment.gross = 100.00
      payment.status = Payment::COMPLETE
      payment.currency = 'CAD'
      payment.payer_id = 'XIE93XOIEUTEEEEEEEEE'

      result = payment.save
      result.should be_true
    end
  end

  context 'Payment fraud checks' do
    # This is especially important to perform this check if you use PDT with IPN and update your database with data from each.
    specify 'Check that the txn_id is unique, to prevent a fraudster from reusing an old transaction.' do
      transaction_id = '6G996328CK404320L'
      payment = Payment.new
      payment.transaction_id = transaction_id
      payment.gross = 100.00
      payment.currency = 'CAD'
      payment.save

      result = Payment.new_transaction?(transaction_id)      
      result.should be_false
    end

    # This is especially important to perform this check if you use PDT with IPN and update your database with data from each.
    specify 'Pending transaction must be processed.' do
      transaction_id = '6G996328CK404320L'
      payment = Payment.new
      payment.transaction_id = transaction_id
      payment.gross = 100.00
      payment.currency = 'CAD'
      payment.status = Payment::PENDING
      payment.save

      result = Payment.existing_incomplete_transaction?(transaction_id)      
      result.should be_true
    end

    # This is especially important to perform this check if you use PDT with IPN and update your database with data from each.
    specify 'Check that the txn_id is unique, to prevent a fraudster from reusing an old, completed transaction.' do
      transaction_id = '6G996328CK404320L'
      payment = Payment.new
      payment.transaction_id = transaction_id
      payment.gross = 100.00
      payment.currency = 'CAD'
      payment.status = Payment::COMPLETE
      payment.save

      result = Payment.existing_incomplete_transaction?(transaction_id)      
      result.should be_false
    end
  end
end
