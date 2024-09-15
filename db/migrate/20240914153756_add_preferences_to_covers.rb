class AddPreferencesToCovers < ActiveRecord::Migration[7.0]
  def change
    add_column :covers, :preferences, :jsonb, default: {}
  end
end
