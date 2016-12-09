require 'spec_helper'

RSpec.describe "users/show", type: :view do
    before(:each) do
        @user = FactoryGirl.create(:user_with_boards)
        @pins = @user.pins
    end
    
    after(:each) do
        if !@user.destroyed?
            @user.pins.destroy_all
            @user.destroy
        end


    it "renders attributes in <p>" do
        render
        @user.pins.each do |pin|
            expect(rendered).to match(pin.title)
            expect(rendered).to match(@user.first_name)
            expect(rendered).to match(@user.last_name)
            expect(rendered).to match(@user.email)
        end
      end
    end
end
    
    
    
    
    #    it "renders attributes in <p>" do
    #    render
    #    expect(rendered).to match(@user.first_name)
    #    expect(rendered).to match(@user.last_name)
    #    expect(rendered).to match(@user.email)
        #   end
        #end




