module Admin
  class StaffingRequestsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index

      if params[:search].present?
        search(StaffingRequest)
      else
        resources, search_term = setup_index(params)
        resources = resources.includes(:user, :hospital)

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }

      end
    end

    def find_care_givers
      @staffing_request = StaffingRequest.find(params[:id])
      page = params[:page] ? params[:page].to_i : 1
      @users = @staffing_request.find_care_givers(params[:max_distance].to_i, page)      
    end

    def manual_shift_search_user
      @staffing_request_id = params[:staffing_request_id]
    end

    def manual_shift
      # Find the user
      @user = nil
      begin
        if(params[:user_id])
          @user = User.find(params[:user_id])
        elsif (params[:user_id])
          @user = User.find_by_email(params[:email])
        end
      rescue 
      end
      
      if(@user == nil)
        # Redirect to the newly created shift
        flash[:error] = "Manual shift creation unsuccessfull: No user found"
        redirect_to manual_shift_search_user_admin_staffing_requests_path(staffing_request_id: params[:id])
      else      
        @staffing_request = StaffingRequest.find(params[:id])
        logger.debug "Creating manual shift for #{@user.id} and #{@staffing_request.id} by #{current_user.id}"
          
        # Check if we already have an open shift for thi user and this request
        if (@staffing_request.shifts.open.where(user_id: @user.id).count > 0)
          flash[:error] = "Manual shift creation unsuccessfull: Open shift already exists for user #{@user.id} and staffing_request #{@staffing_request.id}"
          redirect_to manual_shift_search_user_admin_staffing_requests_path(staffing_request_id: params[:id])
        else
          # Find the request
          # Manually create the shift - all notifications will go out automatically
          preferred_care_giver_selected=false
          manual_assignment=true
          @shift = Shift.create_shift(@user, @staffing_request, preferred_care_giver_selected, manual_assignment)

          # Redirect to the newly created shift
          flash[:success] = "Manual shift creation successfull"
          redirect_to admin_shift_path(@shift)
        end
      end
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

    def destroy
      requested_resource.request_status = "Cancelled"
      if requested_resource.save
        flash[:notice] = "Request Cancelled"
      else
        flash[:error] = requested_resource.errors.full_messages.join("<br/>")
      end
      redirect_to action: :index
    end


    def default_params
      resource_params = params.fetch(resource_name, {})
      order = resource_params.fetch(:order, "start_date")
      direction = resource_params.fetch(:direction, "desc")
      params[resource_name] = resource_params.merge(order: order, direction: direction)
    end

  end
end
