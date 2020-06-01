require "administrate/field/base"

class QrCodeField < Administrate::Field::Base
  def to_s
    data
  end
end
