require 'spec_helper'
require 'helpers/rails_helper'

RSpec.describe User, type: :model do
    #pending "add some examples to (or delete) #{__FILE__}"
    describe "User authenticate method" do
        before(:all) do
            @user = FactoryGirl.create(:user)
            
        end
        
        after(:each) do
            if !@user.destroyed?
                #@user.pins.destroy_all
                @user.destroy
            end
        end
        
        it 'authenticates and returns a user when valid email and password passed in' do
            user = User.authenticate(@user.email, @user.password)
            expect(user).to eq(@user)
        end
    end
    
    describe "Validates" do
        it {should validate_presence_of(:first_name) }
        it {should validate_presence_of(:last_name) }
        it {should validate_presence_of(:email) }
        it {should validate_presence_of(:password) }
        
    end
    
    describe "Uniqueness" do
        it {should validate_uniqueness_of(:email) }

    end
end


