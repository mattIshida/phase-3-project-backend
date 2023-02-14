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

ActiveRecord::Schema.define(version: 2023_02_14_163123) do

  create_table "bills", force: :cascade do |t|
    t.string "bill_id"
    t.string "bill"
    t.string "title"
    t.string "sponsor_id"
    t.string "summary"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_id"
    t.string "commentable_type"
    t.string "content"
    t.string "user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_id"
    t.string "followable_type"
    t.integer "user_id"
  end

  create_table "legislators", force: :cascade do |t|
    t.string "member_id"
    t.string "first_name"
    t.string "last_name"
    t.string "date_of_birth"
    t.string "title"
    t.string "party"
    t.string "state"
    t.string "url"
    t.string "contact_form"
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
    t.string "reactable_id"
    t.integer "value"
    t.integer "user_id"
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
