class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def guides
  end

  def guidesol
  end

  def guidepipe
  end

  def guideventilation
  end

  def guidepuit
  end
end
