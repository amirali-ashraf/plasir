class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.references :store, null: false, foreign_key: true
      t.references :shoe_model, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
