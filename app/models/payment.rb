require 'money'

class Payment < ActiveRecord::Base
  attr_accessible :currency, :gross, :transaction_id
    
  def self.previously_processed?(transaction_id)
    payment = find_by_transaction_id(transaction_id)
    payment.processed?
  end
  
  # Verify that the price, item description, and so on, match the transaction on your website.
  # This check provides additional protection against fraud.
  def self.transaction_has_correct_amount?(transaction_id, gross, currency)
    payment = find_by_transaction_id(transaction_id)
    payment.has_correct_amount?(gross, currency)
  end
    
  def has_correct_amount?(gross, currency)
    paid = Money.new(BigDecimal.new(gross), currency)
    price = Money.new(self.gross, self.currency)
    price == paid
  end
  
end
