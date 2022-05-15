RSpec.describe Stock do
  context 'test:' do
    let!(:stock_low_eaton) {create :stock, :eaton_store, :bozza_shoe_model, :low_item_count}
    let!(:stock_mid_eaton) {create :stock, :eaton_store, :bozza_shoe_model, :mid_item_count}
    let!(:stock_high_eaton) {create :stock, :eaton_store, :bozza_shoe_model, :high_item_count}
    let!(:stock_mid_auburn) {create :stock, :auburn_store, :bozza_shoe_model, :mid_item_count}
    let!(:stock_high_auburn) {create :stock, :auburn_store, :bozza_shoe_model, :high_item_count}
    let!(:stock_low_auburn) {create :stock, :auburn_store, :bozza_shoe_model, :low_item_count}

    it 'check if the last_records function returns correct result' do
      stock_low_eaton
      stock_mid_eaton
      stock_high_eaton
      stock_low_auburn
      stock_mid_auburn
      stock_high_auburn
      last_records = Stock.last_records
      expect(last_records.size).to eq(2)
      expect(last_records.first).to eq(stock_high_eaton)
      expect(last_records.first.store.name).to eq('Eaton')
      expect(last_records.first.shoe_model.name).to eq('BOZZA')
      expect(last_records.first.item_count).to eq(70)
      expect(last_records.second).to eq(stock_low_auburn)
      expect(last_records.second.store.name).to eq('Auburn')
      expect(last_records.second.shoe_model.name).to eq('BOZZA')
      expect(last_records.second.item_count).to eq(2)
    end

    it 'check ordered' do
      stocks = Stock.all.ordered
      expect(stocks.first.item_count).to eq(2)
      expect(stocks.last.item_count).to eq(70)
    end

    it 'check below_lower_limit_suggestions' do
      below_lower_limit_suggestions = stock_low_auburn.below_lower_limit_suggestions
      expect(below_lower_limit_suggestions.size).to eq(1)
      expect(below_lower_limit_suggestions.first.store.name).to eq('Eaton')
    end

    it 'check over_upper_limit_suggestions' do
      over_upper_limit_suggestions = stock_high_eaton.over_upper_limit_suggestions
      expect(over_upper_limit_suggestions.size).to eq(1)
      expect(over_upper_limit_suggestions.first.store.name).to eq('Auburn')
    end
  end
end