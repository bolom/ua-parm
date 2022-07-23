class PlantsController < ApplicationController
  def index
    @plant = Plant.new
    @plants=   Plant
      .search(params[:search])
      .by_pharmacopoeia(params[:pharmacopoeia])
      .by_family(params[:family])
      .by_genus(params[:genus])
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
    @ksp = @plant.species.descriptionables.find_by(key: "KSP").descriptions
    @description = @ksp["general"][0]["description"]
    @natives = []
    @introduced = []

     @plant.species.distributionable.natives.each do |n|
       @natives << n["name"]
     end

     @plant.species.distributionable.introduced.each do |n|
       @introduced << n["name"]
     end
  end

  def edit
    @plant = Plant.find(params[:id])
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
