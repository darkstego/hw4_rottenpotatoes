# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#  flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
 
  row1 = page.find('table#movies tbody/tr', :text => e1).path.match(/tr\[(\d+)\]/)[1].to_i
  row2 = page.find('table#movies tbody/tr', :text => e2).path.match(/tr\[(\d+)\]/)[1].to_i
  assert_operator row1, :<, row2
  
 # page.body.should =~ Regexp.compile(e1 + '.*?' + e2, Regexp::MULTILINE)
  
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(%r{,\s*}).each do |rating|
    check = "check"
    check = "uncheck" if uncheck
    step %{I #{check} "ratings_#{rating}"} 
  end
end

Then /I should (not )?see (.*,.*)/ do |nosee,movie_list|
  nosee = "not " if nosee
  movie_list.split(%r{,\s*}).each do |movie|
    step %{I should #{nosee}see #{movie}} 
  end
end

#Then /I should see (.*,.*)/ do |movie_list|
#  movie_list.split(%r{,\s*}).each do |movie|
#    step %{I should see #{movie}} 
#  end
#end

Then /I should see all of the movies/ do 
  movies = Movie.find(:all)
  assert page.all('table#movies tbody/tr').count.should == movies.length
end

Then /I should see no movies/ do
  assert page.all('table#movies tbody/tr').count.should == 0
end

Then /The Director of "(.*)" should be "(.*)"/i do  |movie,director|
  assert_equal Movie.find_by_title(movie).director, director
end