class ResumeSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at

  def created_at
    object.created_at.strftime('%B %d, %Y %H:%M')
  end
end