class PlantsController < ApplicationController
  def index
    @plants = Plant.all
    @plant = Plant.new
  end

  def destroy
     @plant = Plant.find(params[:id])
     @plant.destroy
     redirect_to plants_url, notice: "Plant was successfully deleted."
   end

   def edit
     @plant = Plant.find(params[:id])
   end

  def create

      @plant = Plant.new(plant_params)

      respond_to do |format|
        if @plant.save
          format.html { redirect_to plants_url, notice: "plant was successfully created" }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
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
