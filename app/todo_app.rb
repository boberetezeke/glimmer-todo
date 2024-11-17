require 'glimmer-dsl-libui'
require_relative 'todo_presenter'
require_relative 'todo_view'

class TodoApp
  include Glimmer

  def initialize
    @presenter = TodoPresenter.new
    @view = TodoView.new(@presenter)
  end

  def launch
    @view.open
  end
end

TodoApp.new.launch