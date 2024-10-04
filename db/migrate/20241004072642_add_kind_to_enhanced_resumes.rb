class AddKindToEnhancedResumes < ActiveRecord::Migration[7.0]
  def change
    add_column :enhanced_resumes, :kind, :string, default: 'enhance'
  end
end
