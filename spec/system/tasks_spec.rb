require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user){create(:user)}

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスクの新規作成ページにアクセス' do
        it 'タスクの新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content("Login required")
        end
      end

      context 'タスクの編集ページにアクセス' do
        it 'タスクの編集ページへのアクセスが失敗する' do
          task = create(:task)
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content("Login required")
        end
      end

      context 'タスクの一覧ページにアクセス' do
        it 'タスクの一覧ページへのアクセスが成功する' do
          visit tasks_path
          expect(current_path).to eq '/tasks'
          expect(page).not_to have_content("Login required")
        end
      end

      context 'タスクの詳細ページにアクセス' do
        it 'タスクの詳細ページへのアクセスが成功する' do
          task = create(:task)
          visit task_path(task)
          expect(current_path).to eq '/tasks/1'
          expect(page).to have_content(task.title)
        end
      end
    end
  end
  describe 'ログイン後' do
    before{login(user)}
    describe 'タスク新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功' do
          visit root_path
          click_link 'New task'
          fill_in 'task_title', with: 'title'
          fill_in 'task_content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'task_deadline', with: DateTime.new(2021, 1, 10, 0, 0)
          click_button 'Create Task'
          expect(page).to have_content("Task was successfully created.")
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成に失敗' do
          visit root_path
          click_link 'New task'
          fill_in 'task_title', with: nil
          fill_in 'task_content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'task_deadline', with: DateTime.new(2021, 1, 10, 0, 0)
          click_button 'Create Task'
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_content("New Task")
          expect(current_path).to eq '/tasks'
        end
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの新規作成に失敗' do
          task = create(:task,title:'title_1')
          visit root_path
          click_link 'New task'
          fill_in 'task_title', with: 'title_1'
          fill_in 'task_content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'task_deadline', with: DateTime.new(2021, 1, 10, 0, 0)
          click_button 'Create Task'
          expect(page).to have_content("Title has already been taken")
          expect(page).to have_content("New Task")
          expect(current_path).to eq '/tasks'
        end
      end
    end
    describe 'タスクの編集確認' do
      let(:task){create(:task,user: user)}
      before{login(user)}
      before{visit edit_task_path(task)}

      context 'フォームの入力値が正常' do
        it 'タスクの編集に成功する' do
          fill_in 'task_title', with: 'title'
          fill_in 'task_content', with: 'content'
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content("Task was successfully updated.")
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集に失敗する' do
          fill_in 'task_title', with: nil
          fill_in 'task_content', with: 'content'
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_content("Editing Task")
        end
      end

      context '登録済みのタイトルを入力' do
        it 'タスクの編集に失敗する' do
          task_registered_title = create(:task,title:'title')
          fill_in 'task_title', with: 'title'
          fill_in 'task_content', with: 'content'
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content("Title has already been taken")
          expect(page).to have_content("Editing Task")
        end
      end
    end
    describe 'ページ遷移確認' do
      context '別ユーザーのタスク編集ページにアクセス' do
        it 'アクセスが失敗する' do
          another_user = create(:user)
          another_user_task = create(:task,user: another_user)
          visit edit_task_path(another_user_task)
          expect(page).to have_content("Forbidden access.")
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
