class School < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:school)
    validates_presence_of :name
end
