# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_14_113107) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_end_time"
    t.text "business_processing_content"
    t.boolean "next_day", default: false
    t.string "instructor_confirmation"
    t.string "instructor"
    t.boolean "change_box"
    t.datetime "change_started_at"
    t.datetime "change_finished_at"
    t.integer "change_confirmation_status"
    t.integer "check_overtime_application"
    t.string "month_superior"
    t.string "month_status"
    t.date "apply_month"
    t.boolean "month_modify", default: false
    t.string "confirmation_superior"
    t.string "confirmation_status"
    t.integer "worked_request_sign"
    t.integer "confirmation_modify"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "approval_date"
    t.string "change_boss"
    t.string "change_month_superior"
    t.integer "check_month_approval"
    t.string "overtime_boss"
    t.boolean "confirmation_next_day"
    t.boolean "overtime_next_day"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "office_number"
    t.string "office_name"
    t.string "office_category"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2021-04-16 23:00:00"
    t.datetime "work_time", default: "2021-04-16 22:30:00"
    t.datetime "work_start_time", default: "2021-04-17 00:00:00"
    t.datetime "work_end_time", default: "2021-04-17 09:00:00"
    t.integer "employee_number"
    t.integer "card_id"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "attendances", "users"
end
