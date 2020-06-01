class UserDocExpiryJob < ApplicationJob
  queue_as :default

  def perform()

    cert_expiry = Date.today - eval(ENV["CERTIFICATE_EXPIRY"])
    id_expiry = Date.today - eval(ENV["ID_CARD_EXPIRY"])
    address_expiry = Date.today - eval(ENV["ADDRESS_PROOF_EXPIRY"])
    dbs_expiry = Date.today - eval(ENV["DBS_EXPIRY"])

    # Ensure all doc types are expired based on settings in .env
    UserDoc.verified.certificates.where("created_at < ?", cert_expiry).each do |doc|
      expire(doc)
    end
    UserDoc.verified.id_cards.where("created_at < ?", id_expiry).each do |doc|
      expire(doc)
    end
    UserDoc.verified.address_proofs.where("created_at < ?", address_expiry).each do |doc|
      expire(doc)
    end
    UserDoc.verified.dbs.where("created_at < ?", dbs_expiry).each do |doc|
      expire(doc)
    end
  end

  def expire(doc)
    doc.update(expired: true)
    doc.user.update(verified: false)
    UserDocExpiryMailer.send_doc_expired_email(doc).deliver_now
  end
end
