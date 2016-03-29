class PinsController < ApplicationController
    before_action :require_login, except: [:index, :show, :show_by_name]
  
  def index
     @pins = Pin.find_by_user_id(current_user.id)
  end
  
  def show
    @pin = Pin.find(params[:id])
  end
  
  def show_by_name
      #search for a Pin using the slug you grab from the URL
      @pin = Pin.find_by_slug(params[:slug])
      render :show
  end

# GET /pin/new
  def new
      @pin = Pin.new
  end
  
# GET /pin/1/edit
  def edit
      @pin = Pin.find(params[:id])
  end

# POST /pin
# POST /pin.json
  def create
      @pin = Pin.new(pin_params)
      if @pin.valid?
          @pin.save
          redirect_to pin_path(@pin)
          else
          @errors = @pin.errors.full_messages
          render :new

      end
 end
  
def update
    @pin = Pin.find(params[:id])
    @pin.update_attributes(pin_params)
    
    if @pin.valid?
        @pin.save
        redirect_to pin_path(@pin)
        else
        @errors = @pin.errors.full_messages
        render :edit
        
    end
end

private

# Use callbacks to share common setup or constraints between actions.
#def set_pin
#@pin = Pin.find(params[:id])
#end

# Never trust parameters from the scary internet, only allow the white list through
  def pin_params
      params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
  end
end