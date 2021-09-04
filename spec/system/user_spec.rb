require 'rails_helper'

RSpec.describe 'step4のテスト', type: :system do
  describe '1,ユーザー登録のテスト' do
    context 'サインアップ画面で必要事項を記入すると、' do
      it "ユーザーの新規登録ができること" do
        visit new_user_path
        fill_in '名前', with: 'test01'
        fill_in 'メールアドレス', with: 'test01@example.com'
        fill_in 'パスワード', with: 'test01'
        fill_in 'パスワード再入力', with: 'test01'
        click_on '登録する'
        expect(page).to have_content 'アカウントが作成できました'
      end
    end
    context 'ログインせずにタスク一覧にアクセスすると、' do
      it "ログイン画面に遷移すること" do
        visit tasks_path
        sleep 0.2
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe '2,セッション機能のテスト' do
    before do
      User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
    end
    context 'ログイン画面で必要事項を記入すると、' do
      it "ログインができること。自分の詳細ページに飛べること" do
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        sleep 0.2
        expect(page).to have_content 'test01のページ'
      end
    end
    context '一般ユーザーが他人の詳細画面にアクセスすると、' do
      it "タスク一覧画面に遷移すること" do
        another = User.create!(name: 'test02', email: 'test02@example.com', password: 'test02', admin: false)
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        visit user_path(another.id)
        sleep 0.2
        expect(page).to have_content 'タスク一覧'
      end
    end
    context 'ログイン状態でログアウトをクリックしたら、' do
      it "ログアウトできること" do
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        sleep 0.2
        click_on 'ログアウト'
        sleep 0.2
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '3,セッション機能のテスト' do
    before do
      User.create!(name: 'test00', email: 'test00@example.com', password: 'test00', admin: true)
      User.create!(name: 'test01', email: 'test01@example.com', password: 'test01', admin: false)
    end
    context '管理者は、' do
      it "管理画面にアクセスできること" do
        visit root_path
        fill_in 'Email', with: 'test00@example.com'
        fill_in 'Password', with: 'test00'
        click_on 'Login'
        sleep 0.2
        click_on '管理者ページ'
        sleep 0.2
        expect(page).to have_content '管理画面'
      end
    end
    context '一般ユーザーは、' do
      it "管理画面にアクセスできないこと" do
        visit root_path
        fill_in 'Email', with: 'test01@example.com'
        fill_in 'Password', with: 'test01'
        click_on 'Login'
        sleep 0.2
        visit admin_users_path
        sleep 0.2
        expect(page).to have_content '管理者権限が必要です'
      end
    end
    context '管理者は、' do
      it "ユーザーの新規登録ができること" do
        visit root_path
        fill_in 'Email', with: 'test00@example.com'
        fill_in 'Password', with: 'test00'
        click_on 'Login'
        sleep 0.2
        click_on '管理者ページ'
        sleep 0.2
        click_on 'ユーザー登録'
        sleep 0.2
        fill_in '名前', with: 'test11'
        fill_in 'メールアドレス', with: 'test11@example.com'
        fill_in 'パスワード', with: 'test11'
        fill_in 'パスワード再入力', with: 'test11'
        click_on '登録する'
        expect(page).to have_content 'ユーザー「test11」を登録しました'
      end
    end
    context '管理者は、' do
      it "ユーザーの詳細画面にアクセスできること" do
        another = User.create!(name: 'test02', email: 'test02@example.com', password: 'test02', admin: false)
        visit root_path
        fill_in 'Email', with: 'test00@example.com'
        fill_in 'Password', with: 'test00'
        click_on 'Login'
        visit user_path(another.id)
        sleep 0.2
        expect(page).to have_content 'test02のページ'
      end
    end
    context '管理者は、' do
      it "ユーザーの編集画面からユーザーを編集できること" do
        another = User.create!(name: 'test02', email: 'test02@example.com', password: 'test02', admin: false)
        visit root_path
        fill_in 'Email', with: 'test00@example.com'
        fill_in 'Password', with: 'test00'
        click_on 'Login'
        visit edit_admin_user_path(another.id)
        fill_in 'メールアドレス', with: 'test02edited@example.com'
        fill_in 'パスワード', with: 'test02'
        fill_in 'パスワード再入力', with: 'test02'
        click_on '更新する'
        sleep 0.2
        expect(page).to have_content 'ユーザー「test02」を更新しました'
      end
    end
    context '管理者は、' do
      it "ユーザーの削除をできること" do
        another = User.create!(name: 'test02', email: 'test02@example.com', password: 'test02', admin: false)
        visit root_path
        fill_in 'Email', with: 'test00@example.com'
        fill_in 'Password', with: 'test00'
        click_on 'Login'
        visit admin_users_path
#        byebug
        find(:xpath, '/html/body/div[2]/table/tbody/tr[2]/td[8]/a').click
#        click_on '削除'
        sleep 0.2
        expect(page).to have_content 'ユーザー「test02」を削除しました'
      end
    end
  end
end
