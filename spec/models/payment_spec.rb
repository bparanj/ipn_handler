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
 
 end
