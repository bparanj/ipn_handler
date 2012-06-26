require 'money'

class Payment < ActiveRecord::Base
  attr_accessible :currency, :gross, :transaction_id
  
  def has_correct_amount?(gross, currency)
    paid = Money.new(BigDecimal.new(gross), currency)
    price = Money.new(self.gross, self.currency)
    price == paid
  end
end
