class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :transaction_id
      t.decimal :gross, precision: 8, scale: 2
      t.string :currency
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
