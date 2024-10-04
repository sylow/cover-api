class CreateEnhancedResumes < ActiveRecord::Migration[7.0]
  def change
    create_table :enhanced_resumes do |t|
      t.references :resume, null: false, foreign_key: true
      t.text :content
      t.jsonb :preferences
      t.string :aasm_state

      t.timestamps
    end
  end
end
