class PlantsController < ApplicationController
  def index
    @plant = Plant.new
    @plants  = []
    if params[:synonym].present?
      @plants =  Plant.by_synonym(params[:synonym]).ordered
    elsif params[:commun].present?
        @plants =  Plant.find(params[:commun])
    else  @plants =  Plant
        .search(params[:search])
        .by_plant(params[:plant])
        .by_pharmacopoeia(params[:pharmacopoeia])
        .by_family(params[:family])
        .by_genus(params[:genus])
        .ordered
    end

    @grouped_options = {
  'North America' => [['United States','US'], 'Canada'],
  'Europe' => ['Denmark','Germany','France']
}
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
    @ksp = @plant.species.ksp
    @description = @plant.species.description
    @natives = @plant.species.natives
    @introduced = @plant.species.introduced
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
    params.require(:plant).permit(:scientific, :pharmacopoeia, :family, name_ids:[], names_attributes: [:label])
  end

end
