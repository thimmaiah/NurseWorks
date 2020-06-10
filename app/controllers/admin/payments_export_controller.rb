module Admin

  class PaymentsExportController < Admin::ApplicationController

    before_action :authenticate_user!

    def index
      @payments = Payment.all.includes(:user, :hospital, :staffing_request)

      if(params[:hospital_id].present?)
        @payments = @payments.where(hospital_id: params[:hospital_id])
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
      when "Nurse"
        template ="nurse"
        @payments = @payments.order("users.first_name, staffing_requests.start_date")
      when "Care Home"
        template = "hospital"
        @payments = @payments.where("payments.hospital_id is not null").order("hospitals.name, staffing_requests.start_date")
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
