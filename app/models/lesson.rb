class Lesson < ApplicationRecord
    include ThinkingSphinx::Scopes

    after_save ThinkingSphinx::RealTime.callback_for(:lesson)
    before_save :embed

    validates_presence_of :link, :link_type, :title
    serialize :specializations, Array
    serialize :key_qualifications, Array

    TYPES = ["Video", "Image"]

    def embed
        self.link = self.link.delete("?").gsub("watchv=", "embed/") if self.link_type == "Video"
    end


    sphinx_scope(:spx_specializations) { |spz|
        {:conditions => {:specializations => spz}}
    }

    sphinx_scope(:spx_key_qualifications) { |qual|
        {:conditions => {:key_qualifications => qual}}
    }

end
