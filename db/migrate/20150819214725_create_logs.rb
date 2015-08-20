class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :customer
      t.string :order_id
      t.text :service
      t.integer :cost
      t.string :origin
      t.string :destination

      t.timestamps null: false
    end
  end
end
