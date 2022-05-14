module StockServices
  class MoveShoeModel
    def initialize(from_store_id, to_store_id, shoe_model_id, movement_count: 10)
      @from_store_id = from_store_id
      @to_store_id = to_store_id
      @shoe_model_id = @shoe_model_id
      @movement_count = movement_count
    end

    def call
      ActiveRecord::Base.transaction do
        from_stock = _from_stock_async(@from_store_id, @shoe_model_id)
        to_stock = _to_stock_async(@to_store_id, @shoe_model_id)
        raise StandardError, "Stock not found" if from_stock.nil? or to_stock.nil?
        _from_stock_out(from_stock)
        _to_stock_in(to_stock)
      end
    end

    private

    def _from_stock_async(from_store_id, shoe_model_id)
      Stock.lock
      .where(store_id: from_store_id, shoe_model_id: shoe_model_id)
      .where('item_count > ?', Stock::LOWER_LIMIT)
      .last
    end

    def _to_stock_async(to_store_id, shoe_model_id)
      Stock.lock
      .where(store_id: to_store_id, shoe_model_id: shoe_model_id)
      .where('item_count < ?', Stock::LOWER_LIMIT)
      .last
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