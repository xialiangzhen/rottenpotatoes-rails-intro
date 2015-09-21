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
    @all_ratings=Movie.all_ratings
    if params[:ratings]!=nil        
        @selected_ratings = params[:ratings]
        @selected_keys=@selected_ratings.keys
    elsif session[:ratings]!=nil
          redirect_to :ratings => session[:ratings] , :sort => params[:sort] and return
         else
          @selected_keys=@all_ratings
        
    end
   
    if params[:sort]==nil
        if session[:sort]!=nil
          redirect_to :ratings => params[:ratings] , :sort => session[:sort] and return
        else
          @movies = Movie.where(rating: @selected_keys) and return
        end
    end
    
    sort = params[:sort]
    
      case sort
      when 'title'
        sort_key='title'
        @title='hilite'
      when 'releasedate'
        sort_key='release_date'
        @releasedate='hilite'       
      end
     @movies = Movie.where(rating: @selected_keys).order(sort_key)
      
  session[:ratings]=params[:ratings]
  session[:sort]=params[:sort]  

    
    
    
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
