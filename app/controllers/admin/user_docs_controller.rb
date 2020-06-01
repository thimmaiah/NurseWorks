module Admin
  class UserDocsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(UserDoc)        
      else
        super
      end
    end

    def new 
      resource = UserDoc.new(user_id: params[:user_id], expiry_date: Date.today + 1.year, verified: true)
      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)
      resource.created_by_user_id = current_user.id
      authorize_resource(resource)

      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

  end
end
