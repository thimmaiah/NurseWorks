module Admin
  class HospitalCarerMappingsController < Admin::ApplicationController
    
    def new   
      resource = resource_class.new(resource_params)
      resource.hospital_id = params[:hospital_id]
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
