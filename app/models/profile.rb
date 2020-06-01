class Profile < ApplicationRecord

	belongs_to :user
	has_many :trainings

	validates_presence_of :user_id, :form_completed_by, :role, :position

end
