# t.string "email", null: false
# t.string "crypted_password"
# t.string "salt"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["email"], name: "index_users_on_email", unique: true

FactoryBot.define do
  factory :user do
    email { "hoge@example.com" }
    password { "password" }
    password_confirmation { "password"}
  end
end
