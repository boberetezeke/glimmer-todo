require 'yaml'
require_relative 'todo_model'
require_relative 'todos_model'

class TodoPresenter
  attr_reader :new_todo

  TODOS_FN = "/Users/stevetuckner/todos.yaml"

  def initialize
    @new_todo = TodoModel.new('')
    load_todos
  end

  def todos
    @todos.todos
  end

  def save_todo
    @todos << @new_todo.dup
    save_todos
  end

  def load_todos
    if File.exist?(TODOS_FN)
      @todos = TodosModel.deserialize(YAML.load(File.open(TODOS_FN)))
    else
      @todos = TodosModel.new
    end
  end

  def save_todos
    File.open(TODOS_FN, 'w') { |f| f.write(@todos.serialize.to_yaml) }
  end
end