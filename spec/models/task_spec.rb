require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
      it 'is valid with all attributes' do
        task = build(:task)
        expect(task).to be_valid
        expect(task.errors[:title]).to be_empty
      end
      it 'is invalid without title' do
        task = build(:task, title: nil)
        expect(task.valid?).to be(false)
        expect(task.errors[:title]).to include("can't be blank")
      end
      it 'is invalid without status' do
        task = build(:task, status: nil)
        expect(task.valid?).to be(false)
        expect(task.errors[:status]).to include("can't be blank")
      end
      it 'is invalid with a duplicate title' do
        task = create(:task)
        task_with_a_duplicate_title = build(:task)
        expect(task_with_a_duplicate_title.valid?).to be(false)
        expect(task_with_a_duplicate_title.errors[:title]).to include("has already been taken")
      end
      it 'is valid with another title' do
        task = create(:task)
        task_with_another_title = build(:task,title: "title2")
        expect(task_with_another_title).to be_valid
        expect(task_with_another_title.errors[:title]).to be_empty
      end
  end
end
