class StdlibController < ApplicationController
  include PathSaver

  prepend_before_action do
    @title = "Ruby Standard Library"
    @collection = Library.stdlib.all
  end

  def index
    render "shared/library_list"
  end
end
