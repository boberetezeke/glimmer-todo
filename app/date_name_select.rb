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

