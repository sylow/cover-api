class ChangeCoverFieldNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :covers, :project, :job_description
    add_column :covers, :cover, :text
  end
end
