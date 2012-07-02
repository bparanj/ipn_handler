require 'spec_helper'

describe Payment do
  specify 'When the transaction flag is true, the transaction has been processed' do
    payment = Payment.new
    payment.transaction_id = 20
    payment.processed = true

    payment.should be_processed
  end

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

  specify 'Check that the transaction is not already processed, identified by the transaction ID' do
    payment = Payment.new
    payment.transaction_id = '6G996328CK404320L'
    payment.processed = false
    payment.save

    already_processed = Payment.previously_processed?('6G996328CK404320L')

    already_processed.should be_false
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
