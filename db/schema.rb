# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_14_180041) do

  create_table "bills", force: :cascade do |t|
    t.string "bill_id"
    t.string "bill"
    t.string "title"
    t.string "sponsor_id"
    t.string "summary"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.integer "commentable_id"
    t.string "content"
    t.string "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type"
    t.integer "followable_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable"
  end

  create_table "legislators", force: :cascade do |t|
    t.string "member_id"
    t.string "first_name"
    t.string "last_name"
    t.string "date_of_birth"
    t.string "title"
    t.string "short_title"
    t.string "party"
    t.string "state"
    t.string "url"
    t.string "twitter_account"
    t.string "facebook_account"
    t.string "youtube_account"
    t.string "contact_form"
    t.float "votes_with_party_pct"
    t.float "votes_against_party_pct"
    t.boolean "in_office"
  end

  create_table "positions", force: :cascade do |t|
    t.string "member_id"
    t.integer "vote_id"
    t.string "bill_id"
    t.string "vote_position"
    t.string "party"
    t.string "state"
    t.string "district"
  end

  create_table "reactions", force: :cascade do |t|
    t.string "reactable_type"
    t.integer "reactable_id"
    t.integer "value"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reactable_type", "reactable_id"], name: "index_reactions_on_reactable"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "user_id"
    t.integer "bill_id"
    t.integer "subject_id"
    t.index ["bill_id"], name: "index_tags_on_bill_id"
    t.index ["subject_id"], name: "index_tags_on_subject_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "roll_call"
    t.string "chamber"
    t.integer "congress"
    t.string "date"
    t.string "time"
    t.string "bill_id"
    t.string "api_uri"
  end

end
