class ShiftCloseJob < ApplicationJob
  queue_as :default

  def perform(shift_id)
  	Rails.logger.info "ShiftCloseJob: Start"


    # Price it
    shift = Shift.find(shift_id)
    Rate.price_actual(shift)
    shift.response_status = "Closed"

    Rails.logger.info "ShiftCloseJob priced shift #{shift.id} @ #{shift.care_home_total_amount}"

    # generate a payment record only if one does not exists - we dont want to generate 2 payments on manual close
    payment = shift.payment ? shift.payment : shift.create_payment
    
    req = shift.staffing_request
    req.request_status = "Closed"

    Shift.transaction do
      shift.save
      req.save
      payment.save
    end

    ShiftMailer.shift_completed(shift, shift.user).deliver_now
    ShiftMailer.shift_completed(shift, shift.staffing_request.user).deliver_now

    Rails.logger.info "ShiftCloseJob: Closed request #{req.id} & shift #{shift.id} with payment #{payment.id}"
    
    Rails.logger.info "ShiftCloseJob: End"

  end
end
