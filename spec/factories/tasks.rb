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
    sequence(:title) { "title_1" }
    content { "content" }
    status { 0 }
    deadline { Time.current.end_of_week }
    association :user
  end
end
