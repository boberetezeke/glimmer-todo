require 'yaml'
require_relative 'todo_model'
require_relative 'todos_model'
require_relative '../lib/date_proxy'
require_relative 'date_name_select'

class TodosPresenter
  TODOS_FN = "/Users/stevetuckner/todos.yaml"

  def initialize(start_date)
    @new_todo = TodoModel.new('', due_date: start_date)
    @due_date_proxy = DateProxy.new(start_date, self, :new_due_date_hash)
    @date_name_select = DateNameSelect.new

    @due_date_proxy.on_change do |date|
      @new_todo.due_date = date
      @date_name_select.update_date(date)
    end
    @date_name_select.on_change do |date|
      @due_date_proxy.update_date(date)
    end

    load_todos
  end

  def todo_text
    [@new_todo, :text]
  end

  def date_names
    @date_name_select.items_binding_array
  end

  def selected_date_name_index
    @date_name_select.index_binding_array
  end

  def due_date
    @due_date_proxy.binding_array
  end

  def after_selected_date_name_index_write(index)
    puts "@selected_date_name_index; #{@selected_date_name_index_value}"
  end

  def valid?
    @new_todo.valid?
  end

  def errors
    @new_todo.errors
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