module Api
  module V1
    class FeedsController < ActionController::API
      def index
        render json: {test: 1}
      end

      def create
        data = feed_params
        # Services::FeedsService::NewFeed.new(data[:store], data[:model], data[:inventory])
        # Services::NewFeedService.new(1,1,1).call

        puts data
        
        store = Store.find_or_create_by(name: data[:store])
        shoe_model = ShoeModel.find_or_create_by(name: data[:model])
        stock = Stock.create({store: store, shoe_model: shoe_model, count: data[:inventory]})
        stock.save!
        result = {
          id: stock.id, 
          store: store.name, 
          store_id: store.id,
          model: shoe_model.name, 
          shoe_model_id: shoe_model.id, 
          inventory: stock.count
        }
        ActionCable.server.broadcast('feed_channel', result)
        # ActionCable.server.broadcast('feed_channel', {:message=>"hello"})
        render json: stock
      end

      private

      def feed_params
        params.permit(:store, :model, :inventory)
      end
    end
  end
end