module Admin
  class ReferencesController < Admin::ApplicationController
    
    def new 
      resource = Reference.new(user_id: params[:user_id])
      render locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

  end
end
