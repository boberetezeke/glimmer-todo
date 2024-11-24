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
