require_relative '../app/todos_presenter'

describe TodosPresenter do
  subject { described_class.new(date) }
  let(:date) { Time.now.to_date }

  describe 'new_todo' do
    it 'is initialized with no text' do
      expect(subject.new_todo.text).to eq('')
    end

    it 'is initialized with the correct date' do
      expect(subject.new_todo.due_date).to eq(date)
    end
  end

  describe 'new_due_date_hash' do
    it 'formats the date correctly' do
      expect(subject.new_due_date_hash).to eq({ mday: date.mday, mon: date.mon, year: date.year})
    end
  end

end