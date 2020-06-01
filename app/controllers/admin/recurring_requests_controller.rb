module Admin
class RecurringRequestsController < Admin::ApplicationController
  
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
  

      def create_for_week
        resource = RecurringRequest.find(params[:id])
        resource.create_for_week
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
      end

  end

end
