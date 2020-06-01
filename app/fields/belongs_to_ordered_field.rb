class BelongsToOrderedField < Administrate::Field::BelongsTo

  def candidate_resources
    associated_class.all.order(:name) # add your custom order here
  end

  # tell this field to use the views of the `Field::BelongsTo` parent class
  def to_partial_path
    "/fields/belongs_to/#{page}"
  end

end