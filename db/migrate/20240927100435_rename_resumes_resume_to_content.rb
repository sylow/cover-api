class RenameResumesResumeToContent < ActiveRecord::Migration[7.0]
  def change
    rename_column :resumes, :resume, :content
  end
end
