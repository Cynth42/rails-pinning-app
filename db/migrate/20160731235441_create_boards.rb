class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :boards, :users
    add_reference :pinnings, :board, index: true
    #displays all users
    users = User.all
    #START LOOP THROUGH ALL USERS
    users.each do |user|
        #creating a board for each user
        board = user.boards.create(name: "My Pins!")
        #START LOOP THROUGH PINNINGS ON A USER
        user.pinnings.each do |pinning|
            #add each pinning to the board we just created
            board.pinnings << pinning
        end
    end
  end
end
  