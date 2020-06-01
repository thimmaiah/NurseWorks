require "administrate/field/base"
class HashField < Administrate::Field::Base
  def to_s
    data
  end
end
