class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :primary_paypal_email
      t.string :custom
      
      t.timestamps
    end
  end
end
