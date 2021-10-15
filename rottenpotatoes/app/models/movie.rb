class Movie < ActiveRecord::Base
  def self.same_director(director)
        self.all.where(director: director)
  end
end
