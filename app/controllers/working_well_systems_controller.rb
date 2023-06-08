class WorkingWellSystemsController < ApplicationController

  def index
    @results = GeoCoolSolver.compute("result_from_form")
    @working_well = @results.first
    # @working_well.new()
  end

  def show
  end

end
