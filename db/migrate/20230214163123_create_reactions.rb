class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.references :reactable, polymorphic: true
      t.integer :value
      t.integer :user_id
      t.timestamps
    end
  end
end
