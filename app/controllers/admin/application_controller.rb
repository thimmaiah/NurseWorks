# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def check_admin
      ok = current_user && (current_user.role == "Super User")
      if ok
        logger.debug "check_admin called with #{current_user.id}"      
        return true
      else
        if current_user 
          raise CanCan::AccessDenied 
        else
          return false
        end
      end
    end

    def scoped_resource
        super
    end

    # Hide links to actions if the user is not allowed to do them      
    def show_action?(action, resource)
      Ability.new(current_user).can? action.to_sym, resource
    end

    # Raise an exception if the user is not permitted to access this resource
    def authorize_resource(resource)
      raise CanCan::AccessDenied unless show_action?(params[:action], resource)
    end

    before_action :default_params

    def default_params
      resource_params = params.fetch(resource_name, {})
      order = resource_params.fetch(:order, "id")
      direction = resource_params.fetch(:direction, "desc")
      params[resource_name] = resource_params.merge(order: order, direction: direction)
    end
    
    before_action :set_paper_trail_whodunnit

    def set_paper_trail_whodunnit
      PaperTrail.request.whodunnit = current_user.id if current_user
    end

    
    def setup_search
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: @resources,
        search_term: params[:search],
        page: page,
        show_search_bar: true
      }
    end

    def show_search_bar?
      true
    end
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    def setup_index(params)
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(scoped_resource,
                                           dashboard_class,
                                           search_term).run
      resources = apply_collection_includes(resources)
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      return resources, search_term
    end

    def search(entity)
      with = params[:with].present? ? eval("{"+params[:with].gsub(/ ?= ?/,":")+"}") : {}
      if params[:search] == "*"
        @resources = entity.search( with: with ).page(params[:page]).per(10)
      else
        @resources = entity.search( ThinkingSphinx::Query.escape(params[:search]), with: with ).page(params[:page]).per(10)
      end
      setup_search
    end


    rescue_from CanCan::AccessDenied do |exception|
      logger.info "Access Denied"
      flash[:notice] = "Access Denied"
      redirect_to admin_root_path
    end
  end
end
