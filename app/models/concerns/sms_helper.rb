module SmsHelper


  def send_shift_sms_notification(shift)
    msg = "You have a new shift assigned at #{shift.hospital.name}. Please open the Connuct Care app and accept or reject the shift."
    send_sms(msg)
  end

  def send_shift_accepted_sms(shift)
    msg = "Shift assigned at #{shift.hospital.name} has been accepted."
    send_sms(msg)
  end

  def send_shift_cancelled_sms(shift)
    msg = "Shift assigned at #{shift.hospital.name} has been cancelled."
    send_sms(msg)
  end

  def send_shift_started_sms(shift)
    msg = "Shift assigned at #{shift.hospital.name} has started."
    send_sms(msg)
  end

  def send_shift_ended_sms(shift)
    msg = "Shift assigned at #{shift.hospital.name} has ended."
    send_sms(msg)
  end

  def send_sms(msg)
    self.user.send_sms(msg)
  end

  
end