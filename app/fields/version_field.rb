require "administrate/field/base"

class VersionField < Administrate::Field::Base
  def to_s
    data.collect(&:reify)
  end

end
