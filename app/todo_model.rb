require 'time'

class TodoModel
  attr_accessor :text, :due_date
  def initialize(text, due_date: nil)
    @text = text
    @due_date = due_date
  end

  def valid?
    true
  end

  def ==(other)
    return false unless other.is_a?(self.class)

    @text = other.text && @due_date == other.due_date
  end

  def serialize
    {
      text: @text,
      due_date: @due_date&.to_time&.strftime('%Y-%m-%d')
    }
  end

  def self.deserialize(yaml)
    text = yaml[:text]
    if yaml[:due_date]
      due_date = Time.strptime(yaml[:due_date], '%Y-%m-%d').to_date
    else
      due_date = nil
    end
    new(text, due_date: due_date)
  end
end