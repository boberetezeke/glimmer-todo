require 'glimmer-dsl-libui'

class TodoView
  include Glimmer

  def initialize(presenter)
    @presenter = presenter
    @window = todo_window
  end

  def open
    @window.open
  end

  def todo_window
    window do
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
      entry do
        stretchy false
        label 'Todo'
        text <=> [@presenter.new_todo, :text]
      end
      date_picker do
        stretchy false

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
    table {
      text_column('Text')
      text_column('Due Date')

      editable true
      cell_rows <=> [@presenter, :todos]
    }
  end
end