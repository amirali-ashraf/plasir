class ShoeModelsController < ApplicationController
  before_action :set_shoe_model, only: %i[ show edit update destroy ]

  # GET /shoe_models or /shoe_models.json
  def index
    @shoe_models = ShoeModel.all
  end

  # GET /shoe_models/1 or /shoe_models/1.json
  def show
  end

  # GET /shoe_models/new
  def new
    @shoe_model = ShoeModel.new
  end

  # GET /shoe_models/1/edit
  def edit
  end

  # POST /shoe_models or /shoe_models.json
  def create
    @shoe_model = ShoeModel.new(shoe_model_params)

    respond_to do |format|
      if @shoe_model.save
        format.html { redirect_to shoe_model_url(@shoe_model), notice: "Shoe model was successfully created." }
        format.json { render :show, status: :created, location: @shoe_model }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shoe_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shoe_models/1 or /shoe_models/1.json
  def update
    respond_to do |format|
      if @shoe_model.update(shoe_model_params)
        format.html { redirect_to shoe_model_url(@shoe_model), notice: "Shoe model was successfully updated." }
        format.json { render :show, status: :ok, location: @shoe_model }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shoe_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shoe_models/1 or /shoe_models/1.json
  def destroy
    @shoe_model.destroy

    respond_to do |format|
      format.html { redirect_to shoe_models_url, notice: "Shoe model was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shoe_model
      @shoe_model = ShoeModel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shoe_model_params
      params.require(:shoe_model).permit(:name)
    end
end
