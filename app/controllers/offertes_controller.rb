class OffertesController < ApplicationController
  before_action :set_offerte, only: [:show, :edit, :update, :destroy]

  # GET /offertes
  # GET /offertes.json
  def index
    @offertes = Offerte.all
  end

  # GET /offertes/1
  # GET /offertes/1.json
  def show
  end

  # GET /offertes/new
  def new
    @offerte = Offerte.new
  end

  # GET /offertes/1/edit
  def edit
  end

  # POST /offertes
  # POST /offertes.json
  def create
    @offerte = Offerte.new(offerte_params)

    respond_to do |format|
      if @offerte.save
        format.html { redirect_to @offerte, notice: 'Offerte was successfully created.' }
        format.json { render :show, status: :created, location: @offerte }
      else
        format.html { render :new }
        format.json { render json: @offerte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offertes/1
  # PATCH/PUT /offertes/1.json
  def update
    respond_to do |format|
      if @offerte.update(offerte_params)
        format.html { redirect_to @offerte, notice: 'Offerte was successfully updated.' }
        format.json { render :show, status: :ok, location: @offerte }
      else
        format.html { render :edit }
        format.json { render json: @offerte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offertes/1
  # DELETE /offertes/1.json
  def destroy
    @offerte.destroy
    respond_to do |format|
      format.html { redirect_to offertes_url, notice: 'Offerte was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offerte
      @offerte = Offerte.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offerte_params
      params.require(:offerte).permit(:projectnaam, :projectnummer, :plaats, :status)
    end
end
