class ChangeResumeToResumesInCovers < ActiveRecord::Migration[7.0]
  def change
    rename_column :covers, :resume, :resume_content
  end
end
