class PlantsController < ApplicationController
  def index
    @plant = Plant.new
    @plants=   Plant
      .search(params[:search])
      .by_pharmacopoeia(params[:pharmacopoeia])
      .by_family(params[:family])
      .ordered
  end

  def new
    @plant = Plant.new
  end

  def destroy
    @plant = Plant.find(params[:id])
    respond_to do |format|
     format.html { redirect_to plants_url, notice: "Plant was successfully deleted." }
     format.turbo_stream
   end
  end

  def show
    @plant = Plant.find(params[:id])
    @synonym = @plant.names.synonym.first
    @commons = @plant.names.commons

    if @synonym.blank?
      @synonym = Name.new
    end
  end

  def edit
    @plant = Plant.find(params[:id])
  end

  def create
  ipni =  plant_params[:scientific]

  #ipni = 
  #fetch images.

  #  @plant = Plant.new(plant_params)
  #  respond_to do |format|
  #    if @plant.save
  #      format.html { redirect_to plants_url, notice: "plant was successfully created" }
  #      format.turbo_stream
  #    else
  #      format.html { render :new, status: :unprocessable_entity }
  #    end
  #  end
  end

  def update
    @plant = Plant.find(params[:id])
    respond_to do |format|
      if @plant.update(plant_params)
        format.html { redirect_to plants_url, notice: "plant was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
  def plant_params
    params.require(:plant).permit(:scientific, :pharmacopoeia, :family)
  end

end
