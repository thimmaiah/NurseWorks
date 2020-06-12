class UserDoc < ApplicationRecord

  belongs_to :user
  has_paper_trail

  after_save ThinkingSphinx::RealTime.callback_for(:user_doc)
  validates_presence_of :doc_type, :user_id, :name

  DOC_TYPES = [ "Degree Certificate", "Adhaar Card", "Profile Picture", "Other" ]

  has_one_attached :doc
  #validates_attachment_file_name :doc, matches: [/png\z/, /jpe?g\z/, /pdf\z/, /JPE?G\z/, /doc\z/, /docx\z/]

  scope :not_rejected, -> { where "verified = true or verified is null" }
  scope :not_expired, -> { where "expired = false" }

  scope :certificates, -> { where doc_type: "Degree Certificate" }
  scope :id_cards, -> { where doc_type: "Adhaar Card" }
  scope :signatures, -> { where doc_type: "Signature" }
  scope :not_signatures, -> { where "doc_type <> 'Signature'" }

  before_create :ensure_flags
  def ensure_flags
    self.expired = false
  end

  after_create :request_verification

  def request_verification
    if(self.doc_type != "Signature")
      UserNotifierMailer.request_verification(self.id).deliver_later
    end
  end

  def doc_url
    self.doc.url
  end
end
