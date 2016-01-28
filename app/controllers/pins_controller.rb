class PinsController < ApplicationController
  
  def index
    @pins = Pin.all
  end
  
  def show
    @pin = Pin.find(params[:id])
  end
  
  def show_by_name
      #search for a Pin using the slug you grab from the URL
      @pin = Pin.find_by_slug(params[:slug])
      render :show
  end
  
  def new
    @pin = Pin.new
  end
end