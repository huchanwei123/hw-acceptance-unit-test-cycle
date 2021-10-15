class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    if params[:ratings].nil? and params[:commit] 
      session.delete(:ratings_to_show) 
      session.delete(:sort) 
    end
    
    @all_ratings = ['G','PG','PG-13','R']
    @ratings_to_show = params[:ratings] || session[:ratings_to_show]
    @sort = params[:sort] || session[:sort] 
    
    case @sort
    when 'title'
     @title_header = 'hilite'
    when 'release_date'
     @release_date_header = 'hilite'
    end
    
    if @ratings_to_show.nil?
      @movies = Movie.all
    else
      @movies = Movie.where(rating: @ratings_to_show.keys)
    end

    @movies = @movies.order(@sort)
    
    session[:sort] = @sort
    session[:ratings_to_show] = @ratings_to_show
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

  # ================= newly added =================
  def same_director
    @movie = Movie.find(params[:id])
    
    if @movie.director.blank?
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    else
      @movies = Movie.same_director(@movie.director)
    end
  end
  # ===============================================

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
