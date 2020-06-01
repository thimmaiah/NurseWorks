module Admin
  class ContactsController < Admin::ApplicationController
    

    def index
      if params[:search].present?
        search(CareHome)
      else
        search_term = params[:search].to_s.strip
        resources = Administrate::Search.new(scoped_resource,
                                             dashboard_class,
                                             search_term).run
        resources = apply_resource_includes(resources)
        resources = order.apply(resources)
        resources = resources.page(params[:page]).per(records_per_page)

        resources = resources.where(user_id: params[:user_id]) if params[:user_id].present?

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }
      end
    end
    
  end
end
