class UserDoc < ApplicationRecord

  belongs_to :user
  has_paper_trail

  after_save ThinkingSphinx::RealTime.callback_for(:user_doc)
  validates_presence_of :doc_type, :user_id, :name

  DOC_TYPES = [ "Qualification Certificate", "ID Card", "Proof of Address", "DBS", "Profile Picture", 
                "CV", "Reference", "DOLS", "Other" ]

  has_attached_file :doc, {validate_media_type: false}
  validates_attachment_file_name :doc, matches: [/png\z/, /jpe?g\z/, /pdf\z/, /JPE?G\z/, /doc\z/, /docx\z/]

  scope :not_rejected, -> { where "verified = true or verified is null" }
  scope :not_expired, -> { where "expired = false" }

  scope :certificates, -> { where doc_type: "Qualification Certificate" }
  scope :id_cards, -> { where doc_type: "ID Card" }
  scope :address_proofs, -> { where doc_type: "Proof of Address" }
  scope :dbs, -> { where doc_type: "DBS" }


  before_create :ensure_flags
  def ensure_flags
    self.expired = false
  end

  after_create :dbs_charge
  after_create :request_verification

  def dbs_charge
    if(self.doc_type == "DBS" && self.user_id != self.created_by_user_id)
      # The super uploaded the DBS
      # Charge the user for it
      # TODO
    end
  end

  def request_verification
    if(self.not_available && self.doc_type == "DBS")
      UserNotifierMailer.doc_not_available(self.id).deliver_later
    else
      UserNotifierMailer.request_verification(self.id).deliver_later
    end
  end

  def doc_url
    self.doc.url
  end
end
