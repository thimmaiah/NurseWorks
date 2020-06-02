module Admin
  class HospitalsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(Hospital)
      else
        resources, search_term = setup_index(params)
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
