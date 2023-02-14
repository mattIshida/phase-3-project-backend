class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.string :followable_id
      t.string :followable_type
      t.integer :user_id
    end
  end
end
