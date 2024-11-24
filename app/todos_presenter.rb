require 'yaml'
require_relative 'todo_model'
require_relative 'todos_model'

class TodosPresenter
  attr_reader :new_todo
  attr_accessor :new_due_date_hash
  attr_accessor :date_names
  attr_accessor :selected_date_name_index

  TODOS_FN = "/Users/stevetuckner/todos.yaml"

  def initialize(start_date)
    @new_todo = TodoModel.new('', due_date: start_date)
    @new_due_date_hash = {}
    @date_names = [
      'Today', 'Tommorrow', 'Custom']
    @selected_date_name_index = 0
    load_todos
  end

  def before_due_date_read(val)
    new_todo.due_date ? { mday: @new_todo.due_date.mday, year: @new_todo.due_date.year, mon: @new_todo.due_date.mon } : {}
  end

  def after_due_date_write(date_hash)
    @new_todo.due_date = Date.new(date_hash[:year], date_hash[:mon], date_hash[:mday])
  end

  def after_selected_date_name_index_write(index)
    puts "@selected_date_name_index; #{@selected_date_name_index}"
  end

  def todos
    @todos.todos
  end

  def save_todo
    @todos << @new_todo.dup
    @new_todo.reset
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