
module FeedServices
  class NewFeedService
    def initialize(store_name, shoe_model_name, inventory_count)
      @store_name = store_name
      @shoe_model_name = shoe_model_name
      @inventory_count = inventory_count
    end
  
    def call
      return ActiveRecord::Base.transaction do
        store = _create_store
        shoe_model = _create_shoe_model
        stock = _create_stock(store, shoe_model)
        OpenStruct.new(
          store: store,
          shoe_model: shoe_model,
          stock: stock
        )
      end
    end

    private
    def _create_store
      Store.find_or_create_by(name: @store_name)
    end

    def _create_shoe_model
      ShoeModel.find_or_create_by(name: @shoe_model_name)
    end

    def _create_stock(store, shoe_model)
      Stock.create({store: store, shoe_model: shoe_model, item_count: @inventory_count})
    end
  end 
end
