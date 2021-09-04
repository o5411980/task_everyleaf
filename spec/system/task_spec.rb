require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit new_task_path
        fill_in 'task[task_name]', with: 'hogehoge'
        fill_in 'task[detail]', with: 'fugafuga'
        click_on '登録する'
        expect(page).to have_content 'hogehoge'
        expect(page).to have_content 'fugafuga'
        user.destroy
      end
    end
  end

  describe '検索機能' do
    before do
#      FactoryBot.create(:task, task_name: "task-1st")
#      FactoryBot.create(:task, task_name: "task-2nd")
    end
    context 'タスク名であいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit tasks_path
        fill_in 'タスク名', with: '2nd'
        click_on '検索'
        sleep 0.2
        task_lists = all('.task_row')
        expect(task_lists[0]).to have_content '2nd'
        user.destroy
      end
    end
    context 'ステータス検索をした場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit tasks_path
        select '未着手', from: '進捗'
        click_on '検索'
        sleep 0.2
        task_lists = all('.task_row')
        expect(task_lists[0]).to have_content '未着手'
        expect(task_lists[1]).to have_content '未着手'
        user.destroy
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit tasks_path
        fill_in 'タスク名', with: '1st'
        select '未着手', from: '進捗'
        click_on '検索'
        sleep 0.2
        task_lists = all('.task_row')
        expect(task_lists[0]).to have_content '1st'
        expect(task_lists[0]).to have_content '未着手'
        user.destroy
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        #テストで使用するためのタスクを作成
#        task = FactoryBot.create(:task, task_name: 'task')
        #タスク一覧ページに遷移
        visit tasks_path
        #visitしたpageに「task」という文字列がhave_contentされているかをexpect(期待して確認)
        expect(page).to have_content 'task'
        #expectの結果が、tureならテスト通過、falseならテスト不通過
        user.destroy
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
#        FactoryBot.create(:task, task_name: 'task1')
#        FactoryBot.create(:task, task_name: 'task2')
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit tasks_path
        sleep 0.2
        task_lists = all('.task_row')
        expect(task_lists[0]).to have_content '2nd'
        expect(task_lists[1]).to have_content '1st'
        user.destroy
      end
    end
    context 'タスクが終了期限の昇順に並んでいる場合' do
      it '終了期限が近いタスクが一番上に表示される' do
#        FactoryBot.create(:task, deadline: '2021-09-01 00:00:00')
#        FactoryBot.create(:task, deadline: '2021-10-01 00:00:00')
#        FactoryBot.create(:task, deadline: '2021-11-01 00:00:00')
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', deadline: '2021-09-01 00:00:00', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', deadline: '2021-10-01 00:00:00', status: 1, user_id: user.id)
        task3 = Task.create(task_name: 'task-3rd', detail: 'hoge', deadline: '2021-11-01 00:00:00', status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit tasks_path
        click_link '終了期限でソート'
        sleep 0.2
#        binding.pry
        task_lists = all('.task_row')
        expect(task_lists[0]).to have_content '2021-09-01 00:00:00'
        expect(task_lists[1]).to have_content '2021-10-01 00:00:00'
        expect(task_lists[2]).to have_content '2021-11-01 00:00:00'
        user.destroy
      end
    end
    context 'タスクが優先順位の高い順に並んでいる場合' do
      it '優先順位が高いタスクが一番上に表示される' do
#        FactoryBot.create(:task, task_name: '1st', priority: 3)
#        FactoryBot.create(:task, task_name: '2nd', priority: 2)
#        FactoryBot.create(:task, task_name: '3rd', priority: 1)
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', priority: 3, status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', priority: 2, status: 1, user_id: user.id)
        task3 = Task.create(task_name: 'task-3rd', detail: 'hoge', priority: 1, status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit tasks_path
#        binding.pry
        click_link '優先順位でソート'
        sleep 0.2
        task_lists = all('.task_row')
        expect(task_lists[0]).to have_content '高'
        expect(task_lists[1]).to have_content '中'
        expect(task_lists[2]).to have_content '低'
        user.destroy
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
#         task = FactoryBot.create(:task)
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', priority: 3, status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', priority: 2, status: 1, user_id: user.id)
        task3 = Task.create(task_name: 'task-3rd', detail: 'poge', priority: 1, status: 1, user_id: user.id)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        Task.all.each do |task|
          visit task_path(task.id)
          expect(page).to have_content task.task_name
          expect(page).to have_content task.detail
        end
        user.destroy
      end
    end
  end
end
