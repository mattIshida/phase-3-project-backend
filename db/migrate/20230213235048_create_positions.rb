class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.string :member_id
      t.integer :vote_id
      t.string :bill_id
      t.string :vote_position
      t.string :party
      t.string :state
      t.string :district
    end
  end
end
