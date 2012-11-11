class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.same_director(id)
    movie = Movie.find(id)
    director = movie.director
    movies = Movie.find_all_by_director(director)
  end
  
end
