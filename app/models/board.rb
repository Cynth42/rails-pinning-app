class Board < ActiveRecord::Base
  validates_presence_of :name, uniqness: true
  
  belongs_to :user
  has_many :pinnings, dependent: :destroy
  has_many :pins, through: :pinnings
  has_many :board_pinners, dependent: :destroy
  
  accepts_nested_attributes_for :board_pinners, allow_destroy: true
end
