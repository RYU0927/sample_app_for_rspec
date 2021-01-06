require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          expect {
            fill_in 'user_email', with: 'hoge@example.com'
            fill_in 'user_password', with: 'password'
            fill_in 'user_password_confirmation', with: 'password'
            click_button 'SignUp'
          }.to change{ User.count }.by(1)
          expect(page).to have_content("User was successfully created."), 'フラッシュメッセージ「User was successfully created.」が表示されていません'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          expect {
            fill_in 'user_email', with: nil
            fill_in 'user_password', with: 'password'
            fill_in 'user_password_confirmation', with: 'password'
            click_button 'SignUp'
          }.to change{ User.count }.by(0)
          expect(page).to have_content("Email can't be blank")
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          user = create(:user,email: 'hoge1@example.com')
          expect {
            fill_in 'user_email', with: 'hoge1@example.com'
            fill_in 'user_password', with: 'password'
            fill_in 'user_password_confirmation', with: 'password'
            click_button 'SignUp'
          }.to change{ User.count }.by(0)
          expect(page).to have_content("Email has already been taken")
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          user = create(:user)
          visit user_path(user)
          expect(page).to have_content("Login required")
          expect(current_path).to eq(login_path)
        end
      end
    end
  end

  describe 'ログイン後' do
    let(:user){create(:user)}
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: 'foo@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'Update'
          expect(page).to have_content("User was successfully updated.")
          expect(current_path).to eq user_path(user)
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: nil
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'Update'
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_content("Editing User")
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          user_registered_email = create(:user,email:'hoge@example.com')
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: 'hoge@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'Update'
          expect(page).to have_content("Email has already been taken")
          expect(page).to have_content("Editing User")
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
        another_user = create(:user)
        login(user)
        visit edit_user_path(another_user)
        expect(page).to have_content("Forbidden access.")
        expect(current_path).to eq user_path(user)
      end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          task = create(:task, user: user)
          login(user)
          visit user_path(user)
          expect(page).to have_content("title_1")
        end
      end
    end
  end
end
