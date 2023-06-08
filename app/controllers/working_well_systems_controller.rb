class WorkingWellSystemsController < ApplicationController

  def index
  end

  def show
    @results = GeoCoolSolver.compute("result_from_form")
  end

end
