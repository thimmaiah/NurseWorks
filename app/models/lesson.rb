class Lesson < ApplicationRecord

    after_save ThinkingSphinx::RealTime.callback_for(:lesson)
    before_save :embed

    def embed
        self.youtube_link = self.youtube_link.delete("?").gsub("watchv=", "embed/")
    end
end
