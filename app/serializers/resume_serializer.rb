class ResumeSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :created_at, :enhanced_resume
  has_one :enhanced_resume

  def created_at
    object.created_at.strftime('%B %d, %Y %H:%M')
  end
end