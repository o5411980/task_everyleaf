require 'rails_helper'
RSpec.describe 'Step5のテスト', type: :system do
  describe 'ラベル選択、変更、機能' do
    context 'ラベルを選択してタスクを新規作成した場合' do
      it '作成したタスクの詳細ページに、選択したラベルが表示される' do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        label = Label.create!(label_name: '要打ち合わせ')
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit new_task_path
        fill_in 'task[task_name]', with: 'hogehoge'
        fill_in 'task[detail]', with: 'fugafuga'
        check '要打ち合わせ'
        click_on '登録する'
        visit task_path(user.tasks[0].id)
        sleep 0.2
        expect(page).to have_content 'hogehoge'
        expect(page).to have_content '要打ち合わせ'
        user.destroy
        label.destroy
      end
    end
    context '編集画面でラベル付きタスクのラベル付けを解除した場合' do
      it '作成したタスクの詳細ページで、選択解除したラベルが表示されない' do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        label = Label.create!(label_name: '要打ち合わせ')
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit new_task_path
        fill_in 'task[task_name]', with: 'hogehoge'
        fill_in 'task[detail]', with: 'fugafuga'
        check '要打ち合わせ'
        click_on '登録する'
        visit edit_task_path(user.tasks[0].id)
        uncheck '要打ち合わせ'
        click_on '更新する'
        visit task_path(user.tasks[0].id)
        sleep 0.2
        expect(page).to have_content 'hogehoge'
        expect(page).not_to have_content '要打ち合わせ'
        user.destroy
        label.destroy
      end
    end
  end

  describe 'ラベル検索機能' do
    before do
#      FactoryBot.create(:task, task_name: "task-1st")
#      FactoryBot.create(:task, task_name: "task-2nd")
    end
    context 'ラベル名で検索をした場合' do
      it "検索したラベルが付いたタスクに絞り込まれる" do
        user = User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
        task1 = Task.create(task_name: 'task-1st', detail: 'fuga', status: 1, user_id: user.id)
        task2 = Task.create(task_name: 'task-2nd', detail: 'hoge', status: 1, user_id: user.id)
        label = Label.create!(label_name: '要打ち合わせ')
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit edit_task_path(user.tasks[1].id)
        check '要打ち合わせ'
        click_on '更新する'
        sleep 0.2
        select '要打ち合わせ', from: 'ラベル'
        click_on '検索'
        sleep 0.2
        task_lists = all('.task_row')
        expect(task_lists.count).to eq 1
        expect(task_lists[0]).to have_content '2nd'
        user.destroy
        label.destroy
      end
    end
  end
end
