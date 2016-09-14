class BoardPinner < ActiveRecord::Base
    validates_presence_of :user_id, :board_id
    
    belongs_to :user
    belongs_to :board
end
