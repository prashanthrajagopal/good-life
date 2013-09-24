class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :purpose
      t.datetime :bill_date
      t.integer :user_id
      t.integer :group_id
      t.float :total
      t.boolean :deleted
      
      t.timestamps
    end
    add_index :bills, :group_id, :unique => false
    add_index :bills, :user_id, :unique => false
    add_index :bills, :bill_date, :unique => false
  end
end