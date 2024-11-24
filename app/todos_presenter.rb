require 'yaml'
require_relative 'todo_model'
require_relative 'todos_model'

class DateProxy
  def initialize(date, presenter, hash_sym, &update_date)
    presenter.send("#{hash_sym}=", to_dash_hash(date))
    @date = date
    @presenter = presenter
    @hash_sym = hash_sym
    @update_date = update_date
  end

  def binding_array
    [
      @presenter,
      @hash_sym,
      on_read: ->(val){ before_due_date_read(val) },
      on_write: ->(val) { after_due_date_write(val) }
    ]
  end

  def before_due_date_read(val)
    @date ? to_dash_hash(@date) : {}
  end

  def after_due_date_write(date_hash)
    @date = to_date(date_hash)
    @update_date.call(@date)
  end

  def to_date(date_hash)
    Date.new(date_hash[:year], date_hash[:mon], date_hash[:mday])
  end

  def to_dash_hash(date)
    { mday: date.mday, year: date.year, mon: date.mon }
  end
end

class TodosPresenter
  attr_reader :new_todo
  attr_accessor :date_names_array
  attr_accessor :new_due_date_hash
  attr_accessor :selected_date_name_index_value

  TODOS_FN = "/Users/stevetuckner/todos.yaml"

  def initialize(start_date)
    @new_todo = TodoModel.new('', due_date: start_date)
    @new_due_date_hash = {}
    @due_date_proxy = DateProxy.new(start_date, self, :new_due_date_hash) { |date| @new_todo.due_date = date }
    @date_names_array = [
      'Today', 'Tommorrow', 'Custom']
    @selected_date_name_index_value = 0
    load_todos
  end

  def todo_text
    [@new_todo, :text]
  end

  def date_names
    [self, :date_names_array]
  end

  def selected_date_name_index
    [
      self,
      :selected_date_name_index_value,
      after_write: ->(val) { after_selected_date_name_index_write(val) }
    ]
  end

  def due_date
    @due_date_proxy.binding_array
  end

  def after_selected_date_name_index_write(index)
    puts "@selected_date_name_index; #{@selected_date_name_index_value}"
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