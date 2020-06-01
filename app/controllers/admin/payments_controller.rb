module Admin
  class PaymentsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?        
        search(Payment)
      else
        super
      end
    end

  end
end
