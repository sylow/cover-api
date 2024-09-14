class CreateCreditTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :transaction_type, null: false
      t.string :description, null: false
      t.references :transactionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
