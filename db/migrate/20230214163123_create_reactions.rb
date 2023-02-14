class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.string :reactable_type
      t.string :reactable_id
      t.integer :value
      t.integer :user_id
    end
  end
end
