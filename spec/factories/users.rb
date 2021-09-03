FactoryBot.define do
  factory :user1 do
    name { "admin" }
    email { "admin@example.com" }
    password { "password" }
    admin {true}
  end

  factory :user2 do
    name { "user" }
    email { "user@example.com" }
    password { "password" }
    admin {false}
  end
end
