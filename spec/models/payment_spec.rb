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
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(100.99, 'CAN')
    result.should be_true 
  end

  specify 'Check gross and currency are correct : Same amount, different currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(100.99, 'US')
    result.should be_false
  end

  specify 'Check gross and currency are correct : Different amount, same currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(200.99, 'CAN')
    result.should be_false
  end

  specify 'Check gross and currency are correct : Different amount, different currency' do
    payment = Payment.new
    payment.gross = 100.99
    payment.currency = 'CAN'

    result = payment.has_correct_amount?(200.99, 'US')
    result.should be_false
  end
 
 end
