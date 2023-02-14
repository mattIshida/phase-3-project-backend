class CreateLegislators < ActiveRecord::Migration[5.2]
  def change
    create_table :legislators do |t|
      t.string :member_id
      t.string :first_name
      t.string :last_name
      t.string :date_of_birth
      t.string :title
      t.string :party
      t.string :state
      t.string :url
      t.string :contact_form
      t.boolean :in_office
    end
  end
end
