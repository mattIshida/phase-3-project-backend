class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :commentable_id
      t.string :commentable_type
      t.string :content
      t.string :user_id
    end
  end
end
