class AddFieldsToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :description, :string
    add_column :packages, :stripe_id, :string
  end
end
