class User < ActiveRecord::Base
    
    validates_presence_of :first_name, :last_name, :email, :password
    validates_uniqueness_of :email
 
    has_secure_password

#   def valid_session
#      controller.stub(current_user: FactoryGirl.create(:user))
#   end

 
    def self.authenticate(email, password)
      @user = find_by_email(email)
    if !@user.nil?
      if @user.authenticate(password)
        return @user
     end
   end
     else
       return nil
     end
end

