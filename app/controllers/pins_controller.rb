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

# GET /people/new
  def new
      @pin = Pin.new
  end
  
# GET /people/1/edit
  def edit
  end

# POST /people
# POST /people.json
  def create
      @pin = Pin.new(pin_params)
      if @pin.valid?
          @pin.save
          redirect_to pin_path(@pin)
          else
          @errors = @pin.errors
          render :new

      end
  end
  
  private
  
  def pin_params
      params.require(:pin).permit(:title, :url, :slug, :text, :category_id)
  end
end