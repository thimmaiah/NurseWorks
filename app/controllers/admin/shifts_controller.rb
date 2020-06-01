module Admin
  class ShiftsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index

      if params[:search].present?
        search(Shift)
      else
        resources, search_term = setup_index(params)
        resources = resources.includes(:user, :care_home)

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }

      end
    end

    def edit
      requested_resource.start_code = requested_resource.staffing_request.start_code
      requested_resource.end_code = requested_resource.staffing_request.end_code
      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource),
      }
    end

    # PATCH/PUT /shifts/1
    def update

      logger.debug "resource_params = #{resource_params}"

      regenerate_payment = false
      if(requested_resource.payment)
        # This has already been closed & payment has been generated
        requested_resource.payment.really_destroy!
        regenerate_payment = true
      end

      updated = false
      if(resource_params["manual_close"] == "1")
        updated = requested_resource.close_manually(resource_params[:start_date], resource_params[:end_date])
      else
        updated = requested_resource.update(resource_params)
      end

      if updated
        # regenrate the payment if required
        ShiftSubscriber.close_shift(requested_resource, true) if regenerate_payment

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

    def resend_start_end_codes
      ShiftMailer.send_codes_to_broadcast_group(requested_resource).deliver_later
      redirect_to(
          [namespace, requested_resource],
          notice: "Start / End Codes Resent.",
        )
    end

  end
end
