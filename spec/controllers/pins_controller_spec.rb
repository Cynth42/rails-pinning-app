require 'spec_helper'
RSpec.describe PinsController do
    describe "GET index" do
        it 'renders the index template' do
            get :index
            expect(response).to render_template("index")
        end
        
        it 'populates @pins with all pins' do
            get :index
            expect(assigns[:pins]).to eq(Pin.all)
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
    end
    
    describe "POST create" do
        before(:each) do
            @pin_hash = {
                title: "Rails Wizard",
                url: "http://railswizard.org",
                slug: "rails-wizard",
                text: "A fun and helpful Rails Resource",
                category_id: "2"}
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
            expect(response).to render_template(:edit)
        end
        
        # renders the edit template
        it 'renders the edit template' do
            get :edit, id: @pin.id
            expect(response).to render_template(:edit)
            expect(response).to be_success
        end
        
        # assigns an instance variable called @pin to the Pin with the appropriate id
        it 'assigns an instance variable called @pin to the Pin with the appropriate id' do
            get :edit, id: @pin.id
            expect(assigns(:pin)).to eq(@pin)
        end
    end
    
    # making a POST request to /pins with valid parameters
     describe "PUT update" do
        let(:update_attributes)do
            {:title => "new title"}
        end
        
        before(:each) do
            @pin = Pin.find(1)
            
            put :update, id: @pin.id, :pin => update_attributes
            @pin.reload
        end
    
        # responds with success
        it 'responds with success' do
            expect(@pin.title).to eq update_attributes[:title]
        end
        
        # updates a pin
        it 'updates a pin' do
            expect(Pin.find_by_title(update_attributes[:title]).present?).to be(true)
        end
        
        # redirects to the show view
        it 'redirects to the show view' do
            expect(response).to redirect_to(pin_url(@pin))
        end
    end
    
    describe "PUT errors" do
        before(:each) do
            @pin = Pin.find(1)
        end
        
        # making a POST request to /pins with invalid parameters
        it 'redisplays edit form on error' do
            # The title is required in the Pin model, so we'll
            # delete the title from the @pin in order
            # to test what happens with invalid parameters
            put :update, id: @pin, pin: {title: nil}
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
    end
    
end
