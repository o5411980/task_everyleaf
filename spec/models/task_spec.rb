require 'rails_helper'
describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスク名が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(task_name: '', detail: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(task_name: '失敗テスト', detail: '')
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
#        byebug
        user = User.create!(name: 'test02', email: 'test02@example.com', password: 'test02', admin: false)
        task = Task.new(task_name: 'hoge', detail: 'fuga', user_id: user.id)
        expect(task).to be_valid
        user.destroy
      end
    end
  end

  describe '検索機能' do
#    let!(:task){FactoryBot.create(:task, task_name: "task-1st")}
#    let!(:second_task){FactoryBot.create(:task, task_name: "task-2nd")}
#    byebug
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含むタスクが絞り込まれる" do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test02', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        expect(Task.search_task_name("task")[0].task_name).to include('task')
        expect(Task.search_task_name("task")[1].task_name).to include('task')
        expect(Task.search_task_name("1st")[0].task_name).not_to include('2nd')
        expect(Task.search_task_name("1st").count).to eq 1
        user.destroy
      end
    end
    context 'scopeメソッドでステータス検索した場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test02', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        expect(Task.search_status("1")[0].status).to eq 1
        expect(Task.search_status("1")[1].status).not_to eq 0
        expect(Task.search_status("1")[1].status).not_to eq 2
        expect(Task.search_status("1")[1].status).not_to eq 3
        expect(Task.search_status("1").count).to eq 2
        user.destroy
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test02', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        expect(Task.search_task_name_and_status("2nd", "1").count).to eq 1
        expect(Task.search_task_name_and_status("2nd", "1")).not_to include('1st')
        expect(Task.search_task_name_and_status("2nd", "1")[0].task_name).to eq 'task-2nd'
        expect(Task.search_task_name_and_status("2nd", "1")[0].status).not_to eq 3
        expect(Task.search_task_name_and_status("2nd", "1")[0].status).not_to eq 2
        expect(Task.search_task_name_and_status("2nd", "1")[0].status).not_to eq 0
        expect(Task.search_task_name_and_status("2nd", "1")[0].status).to eq 1
        user.destroy
      end
    end
  end
end
