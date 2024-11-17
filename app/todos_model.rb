require_relative 'todo_model'

class TodosModel
  attr_reader :todos
  def initialize(todos: [])
    @todos = todos
  end

  def <<(todo)
    @todos << todo
  end

  def serialize
    @todos.map(&:serialize)
  end

  def self.deserialize(yaml)
    new(todos: yaml.map{|y| TodoModel.deserialize(y)})
  end
end