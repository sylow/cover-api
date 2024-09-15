class BaseSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.strftime("%-d %b %H:%M")
  end
end