class RemoveProcessedColumnFromPayments < ActiveRecord::Migration
  def up
    remove_column :payments, :processed
  end

  def down
  end
end
