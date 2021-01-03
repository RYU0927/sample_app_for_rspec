require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
      it 'is valid with all attributes' do
        task = build(:task)
        expect(task).to be_valid
      end
      it 'is invalid without title' do
        task = build(:task, title: nil)
        expect(task.valid?).to be(false)
        expect(task.errors[:title]).to include("can't be blank")
      end
      it 'is invalid without status' do
        task = build(:task, status: nil)
        task.valid?
        expect(task.valid?).to be(false)
        expect(task.errors[:status]).to include("can't be blank")
      end
      it 'is invalid with a duplicate title' do
        task1 = create(:task)
        task2 = build(:task)
        expect(task2.valid?).to be(false)
        expect(task2.errors[:title]).to include("has already been taken")
      end
      it 'is valid with another title' do
        task1 = create(:task)
        task2 = build(:task,title: "title2")
        expect(task2).to be_valid
      end
  end
end
