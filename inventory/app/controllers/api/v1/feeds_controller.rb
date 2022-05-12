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
        stock = Stock.create({store: store, shoe_model: shoe_model, item_count: data[:inventory]})
        stock.save!

        html_table = ApplicationController.render(
          layout: false,
          partial: 'stores/store_inventory',
          locals: { store: store },
        )
        ActionCable.server.broadcast('feed_channel', {
          html_table: html_table, 
          below_lower_limit_count: store.stocks.last_records.below_lower_limit.size,
          store_name: store.name.parameterize,
          over_upper_limit_count: store.stocks.last_records.over_upper_limit.size
        })
        render json: stock
      end

      private

      def feed_params
        params.permit(:store, :model, :inventory)
      end
    end
  end
end