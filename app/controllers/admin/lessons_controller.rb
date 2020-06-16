module Admin
  class LessonsController < Admin::ApplicationController
    
    def index
      if params[:search].present?
        search(Lesson)
      else
        resources, search_term = setup_index(params)

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
