module ApplicationHelper
  def to_b field
    field.to_i == 0 ? false : true
  end
end
