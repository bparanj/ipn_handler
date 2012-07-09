class Order < ActiveRecord::Base
  attr_accessible :status
  
  def fulfill
    status = 'fulfill'
    save
  end
  
  def self.mark_ready_for_fulfillment(id)
    order = find(id)
    order.fulfill
  end
end
