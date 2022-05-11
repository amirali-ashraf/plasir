
module FeedServices
  class NewFeedService
    def initialize(store_name, model_name, inventory_count)
      @store_name = store_name
      @model_name = model_name
      @inventory_count = inventory_count
    end
  
    def call
      store = Store.find_or_create_by(name: @store_name)
      shoe_model = ShoeModel.find_or_create_by(name: @model_name)
      stock = Stock.find_or_create_by({store: store, shoe_model: shoe_model, count: @inventory_count})
      # inventory = Stock.update({store: store, shoe_model: shoe_model, count: @inventory_count})
    end
  end 
end
