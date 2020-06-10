module ConfirmHelper
  def send_confirm?
    nct = self.next_confirm_time
    sendFlag =  nct && Time.now > nct && # Time to send the confirm
    			self.response_status == 'Accepted' &&   
                self.start_code == nil && # Shift has not yet started
                self.confirmed_status != "Declined" # Shift has not been rejected by the carer
                
    logger.debug("Shift: sendFlag = #{sendFlag}")
    return sendFlag
  end

  def next_confirm_time
    # ACCEPTED_SLOT_REMINDERS_BEFORE="1.day,4.hours,1.hour"
    reminders = ENV["ACCEPTED_SLOT_REMINDERS_BEFORE"].split(",")
    logger.debug("Shift: next_confirm_time = #{reminders[self.confirm_sent_count]} confirm_sent_count = #{self.confirm_sent_count} ")
    if(reminders.length > self.confirm_sent_count)
      return self.staffing_request.start_date - eval(reminders[self.confirm_sent_count])
    end

    return nil
  end

  def confirmation_sent
    self.confirm_sent_count += 1
    self.confirm_sent_at = Time.now
    self.save!
  end

  def confirm
    self.confirmed_status = "Confirmed"
    self.confirmed_count += 1
    self.confirmed_at = Time.now
    self.save!
  end

  def decline
    self.confirmed_status = "Declined"
    self.confirmed_count += 1
    self.confirmed_at = Time.now
    self.save!
  end

  def confirmation_received?
    self.confirmed_status == "Confirmed" &&  self.confirmed_at > self.confirm_sent_at
  end

end
