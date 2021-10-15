require 'rails_helper'

describe Movie do
    describe "Matched director" do 
        it "find movies from the same director" do
            Movie.create({"title": "ThreeKingdoms", "director": "Kao"})
            Movie.create({"title": "New ThreeKingdoms", "director": "Kao"})

            movies = Movie.same_director("Kao")
            movies = movies.as_json
            expect(movies[0]["director"]).to eq("Kao")
            expect(movies[1]["director"]).to eq("Kao")
            expect(movies[0]["title"]).not_to eq("YoYoYo")
            expect(movies[0]["title"]).to eq("ThreeKingdoms")
            expect(movies[1]["title"]).to eq("New ThreeKingdoms")
        end
    end

    describe "No matched director" do
        it "should not return matches for the different directors" do
            Movie.create({"title": "ThreeKingdoms", "director": "Kao"})
            Movie.create({"title": "WannaSleep", "director": "Hu"})

            movies = Movie.same_director("Hu")
            movies = movies.as_json
            expect(movies[0]["director"]).not_to eq("Kao")
            expect(movies[0]["director"]).to eq("Hu")
        end
    end
end
