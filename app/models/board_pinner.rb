class BoardPinner < ActiveRecord::Base
    validates_presence_of :user_id, :board_id
    
    belongs_to :user, inverse_of: :board_pinners
    belongs_to :board, inverse_of: :board_pinners
end
