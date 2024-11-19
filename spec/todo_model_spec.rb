require_relative '../app/todo_model'
require 'date'

describe TodoModel do
  subject { TodoModel.new('do something', due_date: Date.new(2024,3,1)) }

  describe '#serialize' do
    it 'serializes correctly with only text' do
      subject.due_date = nil
      expect(subject.serialize).to eq({ text: 'do something', due_date: nil })
    end

    it 'serializes correctly with a due_date' do
      expect(subject.serialize).to eq({ text: 'do something', due_date: '2024-03-01' })
    end
  end

  describe '.deserialize' do
    it 'deserializes correctly without due_date' do
      todo = described_class.deserialize({ text: 'do something', due_date: nil })
      expect(todo.text).to eq('do something')
      expect(todo.due_date).to be_nil
    end

    it 'deserializes correctly with due_date' do
      todo = described_class.deserialize({ text: 'do something', due_date: '2024-03-01' })
      expect(todo.text).to eq('do something')
      expect(todo.due_date).to eq(Date.new(2024,3,1))
    end
  end
end
