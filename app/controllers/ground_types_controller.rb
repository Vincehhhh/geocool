class GroundTypesController < ApplicationController

  def index
    @ground_types = GroundType.all

    # @project = current_user.project_ids.last
    @project = Project.where(id: current_user.project_ids.last )
  end

  def edit

  end

  def update

  end
end
