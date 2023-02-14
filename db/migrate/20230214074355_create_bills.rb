class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.string :bill_id
      t.string :bill
      t.string :title
      t.string :sponsor_id
      t.string :summary
    end
  end
end
