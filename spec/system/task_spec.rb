require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task[task_name]', with: 'hogehoge'
        fill_in 'task[detail]', with: 'fugafuga'
        click_on 'Create Task'
        expect(page).to have_content 'hogehoge'
        expect(page).to have_content 'fugafuga'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        #テストで使用するためのタスクを作成
        task = FactoryBot.create(:task, task_name: 'task')
        #タスク一覧ページに遷移
        visit tasks_path
        #visitしたpageに「task」という文字列がhave_contentされているかをexpect(期待して確認)
        expect(page).to have_content 'task'
        #expectの結果が、tureならテスト通過、falseならテスト不通過
      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
         task = FactoryBot.create(:task)
         Task.all.each do |task|
           visit task_path(task.id)
           expect(page).to have_content task.task_name
           expect(page).to have_content task.detail
         end
       end
     end
  end
end
