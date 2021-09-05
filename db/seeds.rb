10.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = "password"
  User.create!(name: name, email: email, password: password, admin: false)
end

11.times do |n|
  task_name = Faker::Lorem.word
  detail = Faker::Lorem.sentence
  user_id = User.first
  Task.create!(task_name: "task-#{task_name}", detail: detail, status: 1, user_id: user_id)
end

11.times do |n|
  label_name = Faker::Lorem.word
  Label.create!(label_name: label_name)
end
