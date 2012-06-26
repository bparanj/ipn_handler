class Payment < ActiveRecord::Base
  attr_accessible :currency, :gross, :transaction_id
  
  def has_correct_amount?(gross, currency)
    (self.gross == gross) && (self.currency == currency)
  end
end
