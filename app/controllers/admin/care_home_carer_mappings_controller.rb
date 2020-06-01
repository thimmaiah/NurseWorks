module Admin
  class CareHomeCarerMappingsController < Admin::ApplicationController
    
    def new   
      resource = resource_class.new(resource_params)
      resource.care_home_id = params[:care_home_id]
      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)
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
