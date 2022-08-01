class NamesController < ApplicationController
  def index
    @name = Name.new
    @names = Name.all
  end

  def create
    @name = Name.new(name_params)
    @plant = Plant.find(params[:plant_id])
    respond_to do |format|
      if @name.save
        format.html { redirect_to names_url, notice: "Name was successfully created" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plant = Plant.find(params[:plant_id])
    @name = Name.find(params[:id])
    @name.destroy
    respond_to do |format|
     format.html { redirect_to names_url, notice: "Name was successfully deleted." }
     format.turbo_stream
   end
  end

  def show
    @name = Name.find(params[:id])
  end

  def edit
    @name = Name.find(params[:id])
  end

  def update
    @name = Name.find(params[:id])
    respond_to do |format|
      if @name.update(name_params)
        format.html { redirect_to names_url, notice: "name was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
  def name_params
    params.require(:name).permit(:plant_id, :label, :category)
  end
end
