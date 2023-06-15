class ContactmanufacturersController < ApplicationController

  def new
    @contact = Contactmanufacturer.new
  end
end
