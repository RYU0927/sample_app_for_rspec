# t.string "title"
# t.text "content"
# t.integer "status"
# t.datetime "deadline"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "user_id"
# t.index ["user_id"], name: "index_tasks_on_user_id"

FactoryBot.define do
  factory :task do
    title { "title" }
    status { 0 }
    association :user
  end
end
