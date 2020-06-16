class Lesson < ApplicationRecord

    after_save ThinkingSphinx::RealTime.callback_for(:lesson)
    before_save :embed

    validates_presence_of :link, :link_type, :title

    TYPES = ["Video", "Image"]

    def embed
        self.link = self.link.delete("?").gsub("watchv=", "embed/") if self.link_type == "Video"
    end
end
