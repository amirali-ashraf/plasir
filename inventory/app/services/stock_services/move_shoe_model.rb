module StockServices
  class MoveShoeModel
    def initialize(from_store_id, to_store_id, shoe_model_id, movement_count: 10)
      @from_store_id = from_store_id
      @to_store_id = to_store_id
      @shoe_model_id = shoe_model_id
      @movement_count = movement_count
    end

    def call
      ActiveRecord::Base.transaction do
        from_stock = _from_stock_async(@from_store_id, @shoe_model_id)
        to_stock = _to_stock_async(@to_store_id, @shoe_model_id)
        _from_stock_out(from_stock)
        _to_stock_in(to_stock)
      end
    end

    private

    def _from_stock_async(from_store_id, shoe_model_id)
      from_stock = Stock.lock
      .where(store_id: from_store_id, shoe_model_id: shoe_model_id)
      .last
      raise StandardError, "from_stock was not found." if from_stock.nil?
      raise StandardError, "from_stock does not have enough items." if from_stock.item_count - @movement_count < Stock::LOWER_LIMIT
      return from_stock
    end

    def _to_stock_async(to_store_id, shoe_model_id)
      to_stock = Stock.lock
      .where(store_id: to_store_id, shoe_model_id: shoe_model_id)
      .last
      raise StandardError, "to_stock was not found." if to_stock.nil?
      raise StandardError, "to_stock has enough items." if to_stock.item_count > Stock::UPPER_LIMIT
      return to_stock
    end

    def _from_stock_out(from_stock)
      Stock.create(
        store_id: from_stock.store_id,
        shoe_model_id: from_stock.shoe_model_id,
        item_count: from_stock.item_count - @movement_count
      )
    end

    def _to_stock_in(to_stock)
      Stock.create(
        store_id: to_stock.store_id,
        shoe_model_id: to_stock.shoe_model_id,
        item_count: to_stock.item_count + @movement_count
      )
    end


  end
end