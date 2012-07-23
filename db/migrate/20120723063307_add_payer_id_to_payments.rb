class AddPayerIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payer_id, :string
  end
end
