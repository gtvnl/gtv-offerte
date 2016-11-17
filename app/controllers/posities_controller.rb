class PositiesController < ApplicationController
  before_action :set_offerte
  before_action :set_positie, only: [:show, :edit, :update, :destroy]

  # GET /posities
  # GET /posities.json
  def index
    @posities = Positie.all
  end

  # GET /posities/1
  # GET /posities/1.json
  def show
  end

  # GET /posities/new
  def new
    @positie = @offerte.posities.new
  end

  # GET /posities/1/edit
  def edit
  end

  # POST /posities
  # POST /posities.json
  def create

    @positie = @offerte.posities.new(positie_params)

    respond_to do |format|
      if @positie.save
        format.html { redirect_to [@offerte, @positie], notice: 'Positie was successfully created.' }
        format.json { render :show, status: :created, location: @positie }
      else
        format.html { render :new }
        format.json { render json: @positie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posities/1
  # PATCH/PUT /posities/1.json
  def update
    respond_to do |format|
      if @positie.update(positie_params)
        format.html { redirect_to @positie, notice: 'Positie was successfully updated.' }
        format.json { render :show, status: :ok, location: @positie }
      else
        format.html { render :edit }
        format.json { render json: @positie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posities/1
  # DELETE /posities/1.json
  def destroy
    @positie.destroy
    respond_to do |format|
      format.html { redirect_to posities_url, notice: 'Positie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_offerte
      @offerte = Offerte.find_by(id: params[:offerte_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_positie
      @positie = Positie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def positie_params
      params.require(:positie).permit(:regel, :fabrikaat, :systeem, :ip, :verdeler, :aantal, :stuksprijs, :offerte_id)
    end
end
