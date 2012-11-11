require 'spec_helper'
require 'factory_girl'
require 'factory_girl_rails'

describe MoviesController do
  describe 'Similar Movies' do
    before(:each) do
      @fake_results = [mock('Movie'), mock('Movie')]
      @fake_movie = FactoryGirl.build(:movie, :title => "foo", :director => "bar")
      Movie.stub(:find).and_return(@fake_movie)
    end
    it 'should call the model method that finds similar movies' do
      Movie.should_receive(:same_director).with("4").and_return(@fake_results)
      get :same_director, :id => 4
    end
    it 'should select the Similar Results template for rendering' do 
      Movie.stub(:same_director).and_return(@fake_results)
      get :same_director, :id => 4
      response.should render_template('same_director')
    end
    it 'should make the TMDb search results available to that template' do
      Movie.stub(:same_director).and_return(@fake_results)
      get :same_director, :id => 4
      assigns(:movies).should == @fake_results
    end
  end
end