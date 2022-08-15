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

ActiveRecord::Schema[7.0].define(version: 2022_08_14_114036) do
  create_table "buildings", force: :cascade do |t|
    t.decimal "total_useful_wastage_height"
    t.decimal "total_useful_wastage_width"
    t.decimal "total_wastage_height"
    t.decimal "total_wastage_width"
    t.decimal "liner_meter"
    t.decimal "sq_meter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "windows", force: :cascade do |t|
    t.integer "window_width"
    t.integer "window_height"
    t.integer "window_watage_width"
    t.integer "window_wastage_height"
    t.integer "window_instllation_pice"
    t.integer "window_roll_width"
    t.integer "window_roll_height"
    t.string "window_message"
    t.integer "window_useful_height"
    t.integer "window_useful_width"
    t.integer "window_wastage_pice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "building_id"
  end

end
