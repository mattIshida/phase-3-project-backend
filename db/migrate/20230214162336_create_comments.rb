class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.string :content
      t.string :user_id
      t.timestamps
    end
  end
end
