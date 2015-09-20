class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort]
    case sort
    when 'title'
      @movies = Movie.order('title').all
      @title='hilite'
    when 'releasedate'
      @movies = Movie.order('release_date').all
      @releasedate='hilite'
    when nil
      @movies = Movie.all
    end
    
    @all_ratings=Movie.all_ratings
    @selected_ratings = params[:ratings]
    if @selected_ratings == nil
      @selected_ratings={}
      @movies=Movie.all
    else
    @selected_keys=@selected_ratings.keys
    @movies = Movie.where(rating: @selected_keys)
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end  
