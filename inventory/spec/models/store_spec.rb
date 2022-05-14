RSpec.describe ShoeModel do
  context 'test:' do
    let!(:store_1) {create :store, :eaton}

    it 'checks if the name is correct' do
      expect(store_1.name).to eq('Eaton')
    end
  end
end