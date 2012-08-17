class AddFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :amount, :decimal, precision: 8, scale: 2
    add_column :payments, :payment_method, :string
    add_column :payments, :description, :string
    add_column :payments, :status, :string
    add_column :payments, :test, :string
    add_column :payments, :payer_email, :string
  end
end