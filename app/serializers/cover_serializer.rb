class CoverSerializer < BaseSerializer
  attributes :id, :job_description, :resume_title,
              :resume, :resume_content, :cover,
              :preferences, :aasm_state, :created_at

  def resume_title
    object.resume.title
  end
end