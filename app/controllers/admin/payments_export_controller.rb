module Admin

  class PaymentsExportController < Admin::ApplicationController

    before_action :authenticate_user!

    def index
      @payments = Payment.all.includes(:user, :care_home, :staffing_request)

      if(params[:care_home_id].present?)
        @payments = @payments.where(care_home_id: params[:care_home_id])
      end

      if(params[:user_id].present?)
        @payments = @payments.where(user_id: params[:user_id])
      end

      if(params[:created_at_start].present?)
        @payments = @payments.where("payments.created_at >= ?", params[:created_at_start])
      end

      if(params[:created_at_end].present?)
        @payments = @payments.where("payments.created_at <= ?", params[:created_at_end])
      end


      case params[:report_format]
      when "Carer"
        template ="carer"
        @payments = @payments.order("users.first_name, staffing_requests.start_date")
      when "Care Home"
        template = "care_home"
        @payments = @payments.where("payments.care_home_id is not null").order("care_homes.name, staffing_requests.start_date")
      when "Both"
        template = "both"
      end

      logger.info "################## #{params[:report_format]}, #{template}"
      render xlsx: "admin/payments_export/#{template}"
    end
  end

  def form
    render "form"
  end

end
