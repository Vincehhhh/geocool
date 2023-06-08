class ProjectsController < ApplicationController

  def index
    @results = GeoCoolSolver.compute("result_from_form")
  end
end
