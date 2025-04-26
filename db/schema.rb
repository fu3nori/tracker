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

ActiveRecord::Schema[8.0].define(version: 2025_04_23_093205) do
  create_table "invitations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", null: false, comment: "email"
    t.integer "project_id", null: false, comment: "project_id"
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.index ["email"], name: "email"
    t.index ["project_id"], name: "project_id"
  end

  create_table "project_members", id: { type: :integer, comment: "ID" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", null: false, comment: "プロジェクトID"
    t.integer "user_id", null: false, comment: "user_id"
    t.integer "owner", default: 0, null: false, comment: "0=メンバー、1=プロジェクトオーナー"
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.index ["owner"], name: "owner"
    t.index ["project_id"], name: "project_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "project_tasks", id: { type: :integer, comment: "連番" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_member_id", null: false, comment: "プロジェクトメンバーID"
    t.integer "project_id", null: false, comment: "プロジェクトID"
    t.integer "task_status", default: 0, null: false, comment: "0=未着手 1=着手中 2=完了"
    t.string "task_name", null: false
    t.text "task_description", null: false
    t.date "start_day", comment: "開始日"
    t.date "limit_day", comment: "締切日"
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.index ["project_id"], name: "project_id"
    t.index ["project_member_id"], name: "project_member_id"
    t.index ["task_status"], name: "task_status"
  end

  create_table "projects", id: { type: :integer, comment: "プロジェクトID" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "プロジェクトオーナーID"
    t.string "project_name", null: false, comment: "プロジェクト名"
    t.string "description", limit: 1024, null: false, comment: "説明"
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }, null: false, comment: "作成日"
    t.datetime "updated_at", precision: nil, default: -> { "current_timestamp()" }, null: false, comment: "更新日"
    t.index ["user_id"], name: "user_id"
  end

  create_table "users", id: { type: :integer, comment: "ユーザーID", unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", null: false, comment: "ユーザーemail(ユニーク)"
    t.integer "role", default: 1, null: false, comment: "無料ユーザー=1、管理ユーザー=2、プレミアムプランユーザー=3、プロダクションプランユーザー=4"
    t.string "pen_name", null: false, comment: "ペンネーム"
    t.integer "zip_code", comment: "郵便番号(有償案件のプロジェクトのみ)"
    t.text "addres", comment: "住所（有償案件のみ）"
    t.text "real_name", comment: "本名（有償案件のみ）"
    t.text "bank", comment: "振込先（有償案件のみ）"
    t.string "password_digest", limit: 1024, null: false
    t.string "one_time_token", comment: "パスワードを忘れた時に再発行に必要なワンタイムトークンを発行"
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.index ["email"], name: "email", unique: true
  end
end
