FactoryBot.define do
  factory :task do
    task_name { 'FactoryBotデフォルトのタイトル1' }
    detail { 'test_content' }
    status { '1' }
    association :user
  end

  factory :second_task, class: Task do
    task_name { 'FactoryBotデフォルトのタイトル1' }
    detail { 'test_content' }
    status { '1' }
    association :user
  end
end
