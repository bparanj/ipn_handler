class Order < ActiveRecord::Base
  attr_accessible :status
  
  def fulfill
    status = 'fulfill'
    save
  end
end
