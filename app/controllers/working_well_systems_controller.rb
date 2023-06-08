class WorkingWellSystemsController < ApplicationController

  def index
<<<<<<< HEAD
  end

  def show
=======
    @results = GeoCoolSolver.compute("result_from_form")
>>>>>>> master
  end

end
