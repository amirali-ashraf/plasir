class Stock < ApplicationRecord
  belongs_to :store
  belongs_to :shoe_model

  scope :last_records, -> () {
    where(
      id: Stock.group(:store_id, :shoe_model_id).pluck('MAX(id)')
    )
  }
  scope :ordered, -> (order_type=:asc) {order(item_count: order_type)}
  scope :below_lower_limit, -> () {where('item_count < ?', Stock::LOWER_LIMIT)}
  scope :over_upper_limit, -> () {where('item_count > ?', Stock::UPPER_LIMIT)}

  LOWER_LIMIT = 10
  UPPER_LIMIT = 50

  def below_lower_limit_suggestions
    Stock.last_records
    .where.not(store_id: self.store_id)
    .where(shoe_model_id: shoe_model_id)
    .where('item_count >= ?', Stock::LOWER_LIMIT)
    .ordered(:desc)
  end

  def over_upper_limit_suggestions
    Stock.last_records
    .where.not(store_id: self.store_id)
    .where(shoe_model_id: shoe_model_id)
    .where('item_count <= ?', Stock::UPPER_LIMIT)
    .ordered
  end
  
end
