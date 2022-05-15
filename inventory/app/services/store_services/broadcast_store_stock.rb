module StoreServices
  class BroadcastStoreStock
    def initialize(store_id)
      @store = Store.find_by_id(store_id)
    end

    def call
      _broadcast(_prepare_html)
    end

    private
    def _prepare_html
      ApplicationController.render(
        layout: false,
        partial: 'stores/store_inventory',
        locals: { store: @store },
      )
    end

    def _broadcast(html_table)
      ActionCable.server.broadcast('feed_channel', {
        html_table: html_table,
        below_lower_limit_count: @store.stocks.last_records.below_lower_limit.size,
        store_name: @store.name.parameterize,
        over_upper_limit_count: @store.stocks.last_records.over_upper_limit.size
      })
    end
  end
end
