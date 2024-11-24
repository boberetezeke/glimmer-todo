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
      horizontal_box do
        combobox do
          items <=> [@presenter, :date_names]
          selected <=> [@presenter, :selected_date_name_index, after_write: ->(val) { @presenter.after_selected_date_name_index_write(val) }]
        end
        date_picker do
          time <=> [
            @presenter,
            :new_due_date_hash,
            on_read: ->(val){ @presenter.before_due_date_read(val) },
            on_write: ->(val) { @presenter.after_due_date_write(val) }
          ]
        end
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