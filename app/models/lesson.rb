class Lesson < ApplicationRecord

    after_save ThinkingSphinx::RealTime.callback_for(:lesson)
    before_save :embed

    TYPES = ["Video", "Image"]

    def embed
        self.link = self.link.delete("?").gsub("watchv=", "embed/")
    end
end
