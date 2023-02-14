class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.belongs_to :user
      t.belongs_to :bill
      t.belongs_to :subject
    end
  end
end
