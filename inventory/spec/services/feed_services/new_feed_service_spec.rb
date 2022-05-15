RSpec.describe FeedServices::NewFeedService, type: :services do
  context 'test:' do
    it 'checks if new arrived data being stored correctly' do
      result = FeedServices::NewFeedService.new('test_store', 'test_shoe_model', 10).call
      expect(result.store.name).to eq('test_store')
      expect(result.shoe_model.name).to eq('test_shoe_model')
      expect(result.stock.store).to eq(result.store)
      expect(result.stock.shoe_model).to eq(result.shoe_model)
      expect(result.stock.item_count).to eq(10)
      expect(Stock.all.size).to eq(1)
      stock = Stock.first
      expect(stock.store_id).to eq(result.store.id)
      expect(stock.shoe_model_id).to eq(result.shoe_model.id)
      expect(stock.item_count).to eq(result.stock.item_count)
    end
  end
end