module Admin
  class RatingsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(Rating)
      else
        resources, search_term = setup_index(params)
        resources = resources.includes(:hospital, :rated_entity)

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }
      end
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Rating.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
