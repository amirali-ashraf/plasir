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

    StockServices::MoveShoeModel.new(from_store_id, to_store_id, shoe_model_id).call()
    StoreServices::BroadcastStoreStock.new(from_store_id).call()
    StoreServices::BroadcastStoreStock.new(to_store_id).call()    
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
