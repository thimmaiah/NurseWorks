class Rating < ApplicationRecord

  after_save ThinkingSphinx::RealTime.callback_for(:rating)
  COMMENTS = ["Great Work", "Good Work", "Not Bad", "Can Improve"]

  belongs_to :shift
  belongs_to :rated_entity, polymorphic: true
  belongs_to :care_home
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id

  after_create :add_entity_ratings
  after_create :response_rated
  before_destroy :delete_entity_ratings
  before_destroy :response_unrated

  def add_entity_ratings
    self.rated_entity.total_rating = 0 if self.rated_entity.total_rating == nil
    self.rated_entity.rating_count = 0 if self.rated_entity.rating_count == nil
    self.stars = 5 if self.stars == nil

    self.rated_entity.total_rating = self.rated_entity.total_rating + self.stars
    self.rated_entity.rating_count = self.rated_entity.rating_count + 1
    self.rated_entity.save
  end

  def response_rated
    if(rated_entity_type == "User")
      self.shift.rated = true
    else
    	self.shift.care_home_rated = true
    end
    self.shift.save
  end

  def delete_entity_ratings
    self.rated_entity.total_rating =  self.rated_entity.total_rating - self.stars
    self.rated_entity.rating_count =  self.rated_entity.rating_count - 1
    self.rated_entity.save
  end

  def response_unrated
    self.shift.rated = false
    self.shift.save
  end
end
