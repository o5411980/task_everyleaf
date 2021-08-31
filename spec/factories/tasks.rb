FactoryBot.define do
  factory :task do
    task_name { 'test_title' }
    detail { 'test_content' }
    status { '1' }
  end
end
