include Rails.application.routes.url_helpers

class UserDocSerializer < ActiveModel::Serializer
  attributes :id, :name, :doc_type, :user_id, :verified, :doc, 
  :notes, :created_at, :updated_at, :not_available, :secure_doc_url

  def secure_doc_url
  	return url_for(object.doc) 
  end

end
