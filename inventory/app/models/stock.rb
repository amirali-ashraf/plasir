class Stock < ApplicationRecord
  belongs_to :store
  belongs_to :shoe_model

  LOWER_THRESHOLD = 10

  def self.last_records
    where(
      id: Stock.group(:store_id, :shoe_model_id).pluck('MAX(id)')
    )
  end
end
