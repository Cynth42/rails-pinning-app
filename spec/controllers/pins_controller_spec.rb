
require 'spec_helper'

RSpec.describe PinsController do
    before(:each) do
        @user = FactoryGirl.create(:user_with_boards)
        login(@user)
        @board = @user.boards.first
        @board_pinner = BoardPinner.create(user: @user, board: FactoryGirl.create(:board))
        #@category = FactoryGirl.create(:category)
        @pin = FactoryGirl.create(:pin)
    
    end
    
    after(:each) do
        if !@user.destroyed?
            @user.pinnings.destroy_all
            @user.boards.destroy_all
            @user.destroy
        end
    end
        
       #category = Category.find_by_name("rails")
       # if !@category.nil?
       #     @category.destroy
       #end
       #end
    
    describe "GET index" do
        it 'renders the index template' do
            get :index
            expect(response).to render_template("index")
        end
        
        it 'populates @pins with all pins' do
            get :index
            expect(assigns[:pins]).to eq(Pin.all)
        end
        
        it 'redirects to login when not logged in' do
            logout(@user)
            get :index
            expect(response).to redirect_to(:login)
        end
    end
    
    describe "GET new" do
        it 'responds with successfully' do
            get :new
            expect(response.success?).to be(true)
        end
        
        it 'renders the new view' do
            get :new
            expect(response).to render_template(:new)
        end
        
        it 'assigns an instance variable to a new pin' do
            get :new
            expect(assigns(:pin)).to be_a_new(Pin)
        end
        
        it 'assigns @pinnable_boards to all pinnable boards' do
            get :new
            expect(assigns[:pinnable_boards]).to eq(@user.pinnable_boards)
        end
        
        it 'redirects to login when not logged in' do
            logout(@user)
            get :new
            expect(response).to redirect_to(:login)
        end
    end
    
    describe "POST create" do
        before(:each) do
            
            @pin_hash = {
                title: "Rails Wizard",
                url: "http://railswizard.org",
                slug: "rails-wizard",
                text: "A fun and helpful Rails Resource",
                category_id: "2",
                user_id: @user.id,
                pinnings_attributes: [{board_id: @board.id, user_id: @user.id}]
                }
        end
        
        after(:each) do
            pin = Pin.find_by_slug("rails-wizard")
            if !pin.nil?
                pin.destroy
            end
        end
        
        it 'responds with a redirect' do
            post :create, pin: @pin_hash
            expect(response.redirect?).to be(true)
        end
        
        it 'creates a pin' do
            post :create, pin: @pin_hash
            expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
        end
        
        it 'redirects to the show view' do
            post :create, pin: @pin_hash
            expect(response).to redirect_to(pin_url(assigns(:pin)))
            
        end
        
        it 'pins to a board for which the user is a board_pinner' do
            @pin_hash[:pinnings_attributes] = []
            board = @board_pinner.board
            @pin_hash[:pinnings_attributes] << {board_id: @board.id, user_id: @user.id}
            post :create, pin: @pin_hash
            pinning = Pinning.where("board_id=? AND user_id=?", @board.id, @user.id,) #passing an array of pinnings_attributes
            #<set expectation here>
            expect(pinning.present?).to be(true)
            
            if pinning.present?
               pinning.destroy_all
            end
        end
        
        it 'redisplays new form on error' do
            # The title is required in the Pin model, so we'll
            # delete the title from the @pin_hash in order
            # to test what happens with invalid parameters
            @pin_hash.delete(:title)
            post :create, pin: @pin_hash
            expect(response).to render_template(:new)
        end
        
        it 'assigns the @errors instance variable on error' do
            # The title is required in the Pin model, so we'll
            # delete the title from the @pin_hash in order
            # to test what happens with invalid parameters
            @pin_hash.delete(:title)
            post :create, pin: @pin_hash
            expect(assigns[:errors].present?).to be(true)
        end
        
        it 'redirects to login when not logged in' do
            logout(@user)
            post :create, pin: @pin_hash
            expect(response).to redirect_to(:login)
        end
    end
    
    describe "GET edit" do
        before(:each) do
            @pin = Pin.find(1)
        end
        
        # get to pins/id/edit
        # responds successfully
        it 'responds with successfully' do
            get :edit, id: @pin.id
            expect(response.success?).to be(true)
        end
        
        # renders the edit template
        it 'renders the edit template' do
            get :edit, id: @pin.id
            expect(response).to render_template(:edit)
        end
        
        # assigns an instance variable called @pin to the Pin with the appropriate id
        it 'assigns an instance variable called @pin to the Pin with the appropriate id' do
            get :edit, id: @pin.id
            expect(assigns(:pin)).to eq(@pin) #expect(assigns(:pin)).to eq(Pin.find_by_slug(@pin[:slug]))
        end
    
        it 'redirects to login when not logged in' do
            logout(@user)
            get :edit, id: @pin.id
            expect(response).to redirect_to(:login)
        end
    end
    
    # making a POST request to /pins with valid parameters
     describe "PUT update" do
        before(:each) do
            #@user = FactoryGirl.create(:user_with_boards)
            #login(@user)
            #@board = @user.boards.first
            @pin = @board.pins.first
            
            @pin_hash = {
                title: "Rails Wizard",
                url: "http://railswizard.org",
                slug: "rails-wizard",
                text: "A fun and helpful Rails Resource",
                category_id: "2",
                user_id: @user.id,
                pinnings_attributes: [{board_id: @board.id, user_id: @user.id}]
            }
            
          end
         
         after(:each) do
             pin = Pin.find_by_slug("rails-wizard")
             if !pin.nil?
                 pin.destroy
             end
         end

        # responds with success
        it 'responds with success' do
            put :update, pin: @pin_hash, id: @pin.id
            expect(response.redirect?).to be(true)
        end
        
        # updates a pin
        it 'updates a pin' do
            @pin_hash[:title] = "test"
            put :update, pin: @pin_hash, id: @pin.id
            expect(assigns(:pin)[:title]).to eq(@pin_hash[:title])
        end
        
        # redirects to the show view
        it 'redirects to the show view' do
            put :update, pin: @pin_hash, id: @pin.id
            expect(response).to redirect_to(pin_url(@pin))
        end
        
        it 'redirects to login when not logged in' do
            logout(@user)
            get :update, pin: @pin_hash, id: @pin.id
            expect(response).to redirect_to(:login)
        end
    end
    # making a POST request to /pins with invalid parameters
    describe "PUT update errors" do
        
        before(:each) do
           
            @error_hash = {
            title: "",
            url: "",
            slug: "",
            text: "",
            category_id: "",
            user_id: "",
            pinnings_attributes: [{}]
            }

        end
        
        it 'redisplays edit form on error' do
            # The title is required in the Pin model, so we'll
            # delete the title from the @pin in order
            # to test what happens with invalid parameters
            put :update, id: @pin.id, pin: {title: nil}
            # renders the edit view
            expect(response).to  render_template(:edit)
        end
        
        it 'assigns the @errors instance variable on error' do
            # The title is required in the Pin model, so we'll
            # delete the title from the @pin in order
            # to test what happens with invalid parameters
            put :update, id: @pin, pin: {title: nil}
            # assigns an @errors instance variable
            expect(assigns[:errors].present?).to be(true)
        end
        
        it 'renders edit when there is an error' do
            @error_hash[:title] = ""
            put :update, pin: @error_hash, id: @pin.id
            expect(response).to render_template(:edit)
        end

        it 'redirects to login when not logged in' do
            logout(@user)
            get :update, pin: @error_hash, id: @pin.id
            expect(response).to redirect_to(:login)
        end
    end
    
    describe "POST repin" do
        before(:each) do
            @user = FactoryGirl.create(:user_with_boards)
            login(@user)
            @pin = FactoryGirl.create(:pin)

        end
        
        after(:each) do
            pin = Pin.find_by_slug("rails-wizard")
            if !pin.nil?
               pin.destroy
            end
            logout(@user)
        end
        
        it 'responds with a redirect' do
            post :repin, id: @pin.id, pin: { pinning: { board_id: @board.id, user_id: @user.id } }
            expect(response.redirect?).to be(true)
        end
        
        it 'creates a user.pin' do
            post :repin, id: @pin.id, pin: { pinning: { board_id: @board.id, user_id: @user.id } }
            expect(assigns(:pin)).to eq(@pin) #expect(@user.pins.find(@pin.id).id).to eq(@pin.id)
        end
         
        it 'creates a pinning to a board on which the user is a board_pinner' do
            @pin_hash = {
            title: @pin.title,
            url: @pin.url,
            slug: @pin.slug,
            text: @pin.text,
            category_id: @pin.category_id
            }
            board = @board_pinner.board
            @pin_hash[:pinning] = {board_id: board.id}
            post :repin, id: @pin.id, pin: @pin_hash
            pinning = Pinning.where("board_id=?", @board.id) #passing one pinning with a board_id
            #<set expectation here>
            expect(pinning.present?).to be(true)
                               
            if pinning.present?
               pinning.destroy_all
            end
        end
        
        it 'redirects to the user show page' do
            post :repin, id: @pin.id, pin: { pinning: { board_id: @board.id, user_id: @user.id } }
            expect(response).to redirect_to(user_path(@user))
        end
    end
end
