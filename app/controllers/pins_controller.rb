class PinsController < ApplicationController
    before_action :require_login, except: [:show, :show_by_name]
  
  def index
      #@pins = current_user.pins.all
      #Displays all pins
      @pins = Pin.all
  end
  
  def show
    @pin = Pin.find(params[:id])
    #set @users to the pin's users.
    @users = @pin.users
    @board = @pin.pinnings
  end
  
  def show_by_name
      #search for a Pin using the slug you grab from the URL/using a named url instead of the id
      @pin = Pin.find_by_slug(params[:slug])
      #set @users to the pin's users.
      @users = User.joins(:pinnings).where("users.id = ? or pinnings.pin_id = ?", @pin.user_id, @pin.id).distinct #@users = Pin.find_by_slug(params[:slug]).users
      render :show
  end

# GET /pin/new
  def new
      @pin = Pin.new
      @pin.pinnings.build
      @pinnable_boards = current_user.pinnable_boards
  end
  
# GET /pin/1/edit
  def edit
      @pin = Pin.find(params[:id])
      render :edit
      
  end

# POST /pin
# POST /pin.json
  def create
     @pin = current_user.pins.new(pin_params)
     
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

     @pin.pinnings.find_by(params[board_id: @user.boards, user_id: @user.id]).update_attributes(board_id: params[:pin][:pinning][:board_id])
     
     if @pin.valid?
        @pin.save
        redirect_to pin_path(@pin)
     else
        @errors = @pin.errors.full_messages
        render :edit
     end
  end
 
  def repin
      
     @pin = Pin.find(params[:id])
     Pinning.create(user_id: current_user, pin_id: @pin.id, board_id: params[:pin][:pinning][:board_id])
     #redirect to the user's show page
     redirect_to user_path(current_user)
     
     #create a pinning and assign it to the @pin’s pinnings, while setting the user to current_user all at once.
     #@pin.pinnings.create(user: current_user)
     #edirect to the user's show page
     #redirect_to user_path(current_user)
  end
 
#Private methods below:
  private

# Use callbacks to share common setup or constraints between actions.
#def set_pin
#@pin = Pin.find(params[:id])
#end

# Never trust parameters from the scary internet, only allow the white list through
  def pin_params
      puts params.inspect
      params.require(:pin).permit(:title, :category_id, :slug, :url, :text, :image, :user_id, pinnings_attributes: [:board_id, :user_id, :id])
  end
end
