class CreateCovers < ActiveRecord::Migration[7.0]
  def change
    create_table :covers do |t|
      t.references :user, null: false, foreign_key: true
      t.text :project
      t.text :resume
      t.string :aasm_state

      t.timestamps
    end
  end
end
