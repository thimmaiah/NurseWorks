class School < ApplicationRecord
    after_save ThinkingSphinx::RealTime.callback_for(:school)
end
