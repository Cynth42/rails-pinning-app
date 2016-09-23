
# attr_accessor :name, :owner_name, :bark

#  def bark
#     return "woof woof"
#   end
#end


#my_dog = Dog.new
#my_dog.name = "Spot"
#dog_name = my_dog.name
#puts "#{dog_name} says #{my_dog.bark}."

#puts my_dog.inspect
class Song
    
    attr_accessor :name, :lyrics, :musician
    
    def review
        return "one of Wonder's most commercially successful singles!!"
        
    end
end

fav_song = Song.new
fav_song.name = "'I Just called to say I love you'"
fav_song.lyrics = "No New Year's Day, to celebrate. No chocolate covered candy hearts to give away. No first of spring. No song to sing. In fact it's just another ordinary day"
fav_song.musician = "Stevie Wonder"


songname = fav_song.name
songmusician = fav_song.musician
songlyrics = fav_song.lyrics


puts "The partial lyrics to #{fav_song.name} is: #{fav_song.lyrics}. It was written, composed and performed by #{fav_song.musician}. The song was reviewed as #{fav_song.review}"

puts fav_song.inspect

