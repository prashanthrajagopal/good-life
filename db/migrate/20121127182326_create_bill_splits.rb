class CreateBillSplits < ActiveRecord::Migration
  def change
    create_table :bill_splits do |t|
      t.integer :user_id
      t.integer :bill_id
      t.float :paid_amount
      t.float :computed_amount
      t.text :pay_to

      t.timestamps
    end
      add_index :bill_splits, :bill_id, :unique => false
  end
end
