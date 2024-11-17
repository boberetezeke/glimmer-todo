require_relative '../app/todo_model'
require_relative '../app/todos_model'

describe TodosModel do
  subject { TodosModel.new }

  it 'is initialized with an empty array' do
    expect(subject.todos).to eq([])
  end

  describe '<<' do
    it 'adds a todo to the list of todos' do
      todo = TodoModel.new('test')
      subject << todo
      expect(subject.todos).to eq([todo])
    end
  end

  describe '#serialize' do
    it 'serializes each item in the array' do
      todo = double(:todo)
      subject << todo
      expect(todo).to receive(:serialize)
      subject.serialize
    end
  end

  describe '.deserialize' do
    it 'calls TodoModel to deserialize' do
      expect(TodoModel).to receive(:deserialize).and_return(subject)
      todos = described_class.deserialize(['todo_yaml'])
      expect(todos.todos).to eq([subject])
    end
  end
end
