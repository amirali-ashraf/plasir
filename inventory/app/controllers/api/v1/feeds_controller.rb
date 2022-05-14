module Api
  module V1
    class FeedsController < ActionController::API
      def index
        render json: {test: 1}
      end

      def create
        data = feed_params
        result = FeedServices::NewFeedService.new(
          data[:store],
          data[:model],
          data[:inventory]
        ).call
        StoreServices::BroadcastStoreStock.new(result.store.id).call()
        render json: :ok
      end

      private

      def feed_params
        params.permit(:store, :model, :inventory)
      end
    end
  end
end