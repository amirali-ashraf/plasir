class RenamCountStocks < ActiveRecord::Migration[7.0]
  def change
    rename_column :stocks, :count, :item_count
  end
end
