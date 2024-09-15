class AddResumeIdToCovers < ActiveRecord::Migration[7.0]
  def change
    add_reference :covers, :resume, null: false, foreign_key: true
  end
end
