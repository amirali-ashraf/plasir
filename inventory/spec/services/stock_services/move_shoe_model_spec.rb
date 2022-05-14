RSpec.describe StockServices::MoveShoeModel, type: :services do
  context 'test:' do
    let!(:stock_low) {create :stock, :eaton_store, :bozza_shoe_model, :low_item_count}
    let!(:stock_mid) {create :stock, :auburn_store, :bozza_shoe_model, :mid_item_count}
    let!(:stock_high) {create :stock, :auburn_store, :bozza_shoe_model, :high_item_count}

    it 'validate stocks are created properly' do
      expect(stock_low.id).to be_truthy
      expect(stock_low.store_id).to be_truthy
      expect(stock_low.shoe_model_id).to be_truthy
    end

    it 'unable to move from low to high' do
      expect {
        StockServices::MoveShoeModel.new(stock_low.store_id, stock_high.store_id, stock_low.shoe_model_id, movement_count: 100).call
      }.to raise_error(StandardError, "from_stock does not have enough items.")
    end

    it 'error on not enough in storage' do
      expect {
        StockServices::MoveShoeModel.new(stock_mid.store_id, stock_high.store_id, stock_mid.shoe_model_id, movement_count: 100).call
      }.to raise_error(StandardError, "from_stock does not have enough items.")
    end

    it 'error on not enough in storage' do
      expect {
        StockServices::MoveShoeModel.new(stock_high.store_id, stock_mid.store_id, stock_high.shoe_model_id, movement_count: 10).call
      }.to raise_error(StandardError, "to_stock has enough items.")
    end

    it 'should move from high to low successfully' do
      StockServices::MoveShoeModel.new(stock_high.store_id, stock_low.store_id, stock_high.shoe_model_id, movement_count: 10).call
      stock_low_store_id = stock_low.store_id
      stock_low_shoe_model_id = stock_low.shoe_model_id
      stock_high_store_id = stock_high.store_id
      stock_high_shoe_model_id = stock_high.shoe_model_id
      stock_low = Stock.where(store_id: stock_low_store_id, shoe_model_id: stock_low_shoe_model_id).last
      stock_high = Stock.where(store_id: stock_high_store_id, shoe_model_id: stock_high_shoe_model_id).last
      expect(stock_low.item_count).to eq(12)
      expect(stock_high.item_count).to eq(60)
    end
  end
end