class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :credits
      t.integer :price_cents
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
