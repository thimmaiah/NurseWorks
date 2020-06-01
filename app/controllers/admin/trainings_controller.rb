module Admin
  class TrainingsController < Admin::ApplicationController

    def index
      if params[:search].present?        
        search(User)
      else
        super  
      end
    end

    def new   
      resource = Training.new(user_id: params[:user_id], profile_id: params[:profile_id], 
                              expiry_date: Date.today + 1.year, undertaken: true)
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
