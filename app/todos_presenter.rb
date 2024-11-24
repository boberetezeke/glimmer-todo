require 'yaml'
require_relative 'todo_model'
require_relative 'todos_model'

class DateProxy
  attr_accessor :date_hash

  def initialize(date, presenter, hash_sym)
    @date = date
    @presenter = presenter
    @hash_sym = hash_sym
    update_date_hash(@date)
  end

  def on_change(&update_date_block)
    @update_date_block = update_date_block
  end

  def update_date(date)
    @date = date
    update_date_hash(date)
  end

  def update_date_hash(date)
    @date_hash = to_dash_hash(date)
    # @presenter.send("#{@hash_sym}=", to_dash_hash(date))
  end

  def binding_array
    [
      self,
      :date_hash,
      on_read: ->(val){ before_due_date_read(val) },
      on_write: ->(val) { after_due_date_write(val) }
    ]
  end

  def before_due_date_read(val)
    @date ? to_dash_hash(@date) : {}
  end

  def after_due_date_write(date_hash)
    @date = to_date(date_hash)
    @update_date_block.call(@date) if @update_date_block
  end

  def to_date(date_hash)
    Date.new(date_hash[:year], date_hash[:mon], date_hash[:mday])
  end

  def to_dash_hash(date)
    { mday: date.mday, year: date.year, mon: date.mon }
  end
end

class DateNameSelect
  attr_accessor :selected_index_value, :date_names_array
  def initialize
    @selected_index_value = 0
    @date_names_array = ['Today', 'Tomorrow', 'Custom']
  end

  def on_change(&update_date_block)
    @update_date_block = update_date_block
  end

  def update_date(date)
    if date == Time.now.to_date
      self.selected_index_value = 0
    elsif date == Time.now.to_date + 1
      self.selected_index_value = 1
    else
      self.selected_index_value = 2
    end
  end

  def items_binding_array
    [self, :date_names_array]
  end

  def index_binding_array
    [
      self,
      :selected_index_value,
      after_write: ->(val) { after_selected_date_name_index_write(val) }
    ]
  end

  def after_selected_date_name_index_write(index)
    puts "@@selected_index_value; #{@selected_index_value}"
    if @update_date_block
      if index == 0
        @update_date_block.call(Time.now.to_date)
      elsif index == 1
        @update_date_block.call(Time.now.to_date + 1)
      end
    end
  end
end

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