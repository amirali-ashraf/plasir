class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:move]

  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.last_records.includes(:store, :shoe_model).order(store_id: :desc, shoe_model_id: :desc)
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks or /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def move
    from_store_id = params[:move_from_store_id].to_i
    to_store_id = params[:move_to_store_id].to_i
    shoe_model_id = params[:shoe_model_id].to_i

    
    Stock.transaction do
      from_stock = Stock.lock
      .where(store_id: from_store_id, shoe_model_id: shoe_model_id)
      .where('item_count > ?', Stock::LOWER_LIMIT)
      .last

      to_stock = Stock.lock
      .where(store_id: from_store_id, shoe_model_id: shoe_model_id)
      .where('item_count < ?', Stock::LOWER_LIMIT)
      .last

      break if from_stock.nil? or to_stock.nil?

      new_from_stock = Stock.create(
      store_id: from_stock.store_id, 
      shoe_model_id: from_stock.shoe_model_id, 
      item_count: from_stock.item_count - 10
      )
      
      new_to_stock = Stock.create(
      store_id: to_stock.store_id, 
      shoe_model_id: to_stock.shoe_model_id, 
      item_count: to_stock.item_count + 10
      )

      break unless new_from_stock and new_to_stock

      from_store = Store.find(from_stock.store_id)
      to_store = Store.find(to_stock.store_id)

      html_table = ApplicationController.render(
        layout: false,
        partial: 'stores/store_inventory',
        locals: { store: from_store },
      )


      ActionCable.server.broadcast('feed_channel', {
        html_table: html_table, 
        below_lower_limit_count: from_store.stocks.last_records.below_lower_limit.size,
        store_name: from_store.name.parameterize,
        over_upper_limit_count: from_store.stocks.last_records.over_upper_limit.size
      })

      html_table = ApplicationController.render(
        layout: false,
        partial: 'stores/store_inventory',
        locals: { store: to_store },
      )
      ActionCable.server.broadcast('feed_channel', {
        html_table: html_table, 
        below_lower_limit_count: to_store.stocks.last_records.below_lower_limit.size,
        store_name: to_store.name.parameterize,
        over_upper_limit_count: to_store.stocks.last_records.over_upper_limit.size
      })
      render json: {success: true} and return 
    end
    render json: {success: false} and return 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:store_id, :shoe_model_id, :count)
    end
end
