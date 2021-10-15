require 'rails_helper'

describe "Routing test", :type => :request do
    it "when the movie has a director" do
        Movie.create({"title": "ThreeKingdoms", "director": "Kao"})
        Movie.create({"title": "New_ThreeKingdoms", "director": "Kao"})
        
        id =  Movie.where(title: "ThreeKingdoms")[0].as_json["id"]
        get "/movies/#{id}/same_director"
        expect(response).to render_template("same_director")
    end

    it "when the movie has no director" do
        Movie.create({"title": "YoYo"})
        
        id =  Movie.where(title: "YoYo")[0].as_json["id"]
        get "/movies/#{id}/same_director"
        expect(response).to redirect_to("/movies")
    end

    it "Running correctly in general" do
        Movie.create({"title": "ThreeKingdoms", "director": "Kao", "release_date": "2010-01-01"})
        
        get "/movies/1"
        expect(response).to render_template("show")
        
        get "/movies"
        expect(response).to render_template("index")
        
        get "/movies/new"
        expect(response).to render_template("new")
        
        get "/movies/1/edit"
        expect(response).to render_template("edit")
        
        put "/movies/1", "movie": {"title": "YoYo"}
        expect(response).to redirect_to("/movies/1")
        
        delete "/movies/1"
        expect(response).to redirect_to("/movies")
        
    end
    
end
