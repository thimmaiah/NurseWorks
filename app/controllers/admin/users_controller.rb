module Admin
  class UsersController < Admin::ApplicationController
    
    before_action :authenticate_user!

    def index
      if params[:search].present?        
        search(User)
      else
        resources, search_term = setup_index(params)
        resources = resources.includes(:care_home)

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }

      end
    end

    def export
      start_date = params[:created_at_start]
      end_date = params[:created_at_end]
      logger.debug "roles = #{params[:roles]}"
      @resources = User.where("created_at >= ? and created_at <= ?", start_date, end_date)
      @resources = @resources.where(role: params[:roles]) if params[:roles].present?
    end

    def export_form
    end


    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)

        super
        
      else
        if(params[:user][:password] != params[:user][:password_confirmation])
          flash[:error] = "Passwords dont match"
          redirect_to reset_password_admin_user_path(id: params[:id])
        else
          super
        end
      end
      
    end


    def destroy
      @resource = User.find(params[:id])
      if @resource.destroy
        flash[:success] = "Deleted successfully"
        redirect_to action: :index
      else
        flash[:error] = @resource.errors.full_messages
        redirect_to admin_user_path(id: @resource.id)
      end
    end

    def scramble
      @resource = User.find(params[:id])
      if @resource.scramble_personal_data
        flash[:success] = "Scambled successfully"
        redirect_to admin_user_path(id: @resource.id)
      else
        flash[:error] = @resource.errors.full_messages
        redirect_to admin_user_path(id: @resource.id)
      end
    end


    def profile            
      @resource = User.find(params[:id])      
      render "profile", locals: {
        page: Administrate::Page::Form.new(dashboard, @resource)
      }
    end


    def reset_password
        @user = User.find(params[:id])
    end

    def perform_password_reset
      if(params[:user][:password] != params[:user][:password_confirmation])
        flash[:error] = "Passwords dont match"
        redirect_to reset_password_admin_user_path(id: params[:id])
      else
        requested_resource = User.find(params[:user][:id])
        if requested_resource.update(password: params[:user][:password], password_reset_date: Date.today)
          redirect_to(
            [namespace, requested_resource],
            notice: translate_with_resource("update.success"),
          )
        else
          render :edit, locals: {
            page: Administrate::Page::Form.new(dashboard, requested_resource),
          }
        end
      end      
    end

  end
end
