class EnhancedResumeSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :kind, :aasm_state

  def created_at
    object.created_at.strftime('%B %d, %Y %H:%M')
  end
end