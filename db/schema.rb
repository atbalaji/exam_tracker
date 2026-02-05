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

ActiveRecord::Schema[7.1].define(version: 2026_02_04_032533) do
  create_table "exams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "marks_per_correct", default: 1.0, null: false
    t.float "negative_mark", default: 0.0, null: false
    t.index ["name"], name: "index_exams_on_name", unique: true
  end

  create_table "mock_attempts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "exam_id", null: false
    t.date "attempted_on", null: false
    t.string "source"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_mock_attempts_on_exam_id"
    t.index ["user_id"], name: "index_mock_attempts_on_user_id"
  end

  create_table "mock_section_results", force: :cascade do |t|
    t.integer "mock_attempt_id", null: false
    t.integer "section_id", null: false
    t.integer "attempted", null: false
    t.integer "correct", null: false
    t.integer "time_spent_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_questions", null: false
    t.index ["mock_attempt_id", "section_id"], name: "index_mock_section_results_on_mock_attempt_id_and_section_id", unique: true
    t.index ["mock_attempt_id"], name: "index_mock_section_results_on_mock_attempt_id"
    t.index ["section_id"], name: "index_mock_section_results_on_section_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "section_id", null: false
    t.string "topic"
    t.string "difficulty"
    t.text "content", null: false
    t.string "option_a"
    t.string "option_b"
    t.string "option_c"
    t.string "option_d"
    t.string "correct_option", null: false
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_questions_on_section_id"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "section_id", null: false
    t.string "mode"
    t.boolean "timed"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_quiz_attempts_on_section_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "quiz_question_attempts", force: :cascade do |t|
    t.integer "quiz_attempt_id", null: false
    t.integer "question_id", null: false
    t.string "selected_option"
    t.boolean "is_correct"
    t.integer "time_spent_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_quiz_question_attempts_on_question_id"
    t.index ["quiz_attempt_id"], name: "index_quiz_question_attempts_on_quiz_attempt_id"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.string "url"
    t.string "resource_type"
    t.string "tags"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_resources_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "exam_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id", "name"], name: "index_sections_on_exam_id_and_name", unique: true
    t.index ["exam_id"], name: "index_sections_on_exam_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "mock_attempts", "exams"
  add_foreign_key "mock_attempts", "users"
  add_foreign_key "mock_section_results", "mock_attempts"
  add_foreign_key "mock_section_results", "sections"
  add_foreign_key "questions", "sections"
  add_foreign_key "quiz_attempts", "sections"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "quiz_question_attempts", "questions"
  add_foreign_key "quiz_question_attempts", "quiz_attempts"
  add_foreign_key "resources", "users"
  add_foreign_key "sections", "exams"
end
