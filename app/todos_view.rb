require 'glimmer-dsl-libui'

class TodosView
  include Glimmer

  def initialize(presenter)
    @presenter = presenter
    @window = todo_window
  end

  def open
    @window.open
  end

  def todo_window
    window("Todos", 600, 400) do
      margined true

      vertical_box do
        todo_entry_form
        save_button
        todo_table
      end
    end
  end

  def todo_entry_form
    form do
      stretchy false
      entry do
        label 'Todo'
        text <=> [@presenter.new_todo, :text]
      end
      date_picker do
        time year: 2004, mon: 11, mday: 17
      end
    end
  end

  def save_button
    button('Save Todo') do
      stretchy false

      on_clicked do
        if @presenter.new_todo.valid?
          @presenter.save_todo
        else
          msg_box_error('Validation Error!', @presenter.new_todo.errors)
        end
      end
    end
  end

  def todo_table
    table do
      text_column('Text')
      text_column('Due Date')

      editable true
      cell_rows <=> [@presenter, :todos]
    end
  end
end