class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :roll_call
      t.string :chamber
      t.integer :congress
      t.string :date
      t.string :time
      t.string :bill_id
      t.string :api_uri
    end
  end
end
