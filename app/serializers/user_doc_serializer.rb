class UserDocSerializer < ActiveModel::Serializer
  attributes :id, :name, :doc_type, :user_id, :verified, :doc, 
  :notes, :created_at, :updated_at, :not_available

  def secure_doc_url
  	object.doc.expiring_url(300)
  end

end
