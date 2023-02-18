class CreateLegislators < ActiveRecord::Migration[5.2]
  def change
    create_table :legislators do |t|
      t.string :member_id
      t.string :first_name
      t.string :last_name
      t.string :date_of_birth
      t.string :title
      t.string :short_title
      t.string :party
      t.string :state
      t.string :url
      t.string :twitter_account
      t.string :facebook_account
      t.string :youtube_account
      t.string :contact_form
      t.float :votes_with_party_pct
      t.float :votes_against_party_pct
      t.boolean :in_office
    end
  end
end
