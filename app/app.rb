require 'glimmer-dsl-libui'
require_relative 'todos_presenter'
require_relative 'todos_view'

class TodoApp
  include Glimmer

  def initialize
    @presenter = TodosPresenter.new
    @view = TodosView.new(@presenter)
  end

  def launch
    @view.open
  end
end

TodoApp.new.launch