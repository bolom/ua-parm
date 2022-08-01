class AreasController < ApplicationController
  def index
    @areas = Area.all
    @area = Area.new
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    redirect_to areas_url, notice: "Area was successfully deleted."
  end

  def edit
    @area = Area.find(params[:id])
  end

  def create
    @area = Area.new(area_params)
    respond_to do |format|
      if @area.save
        format.html { redirect_to areas_url, notice: "area was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @area = Area.find(params[:id])
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to areas_url, notice: "area was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
  def area_params
    params.require(:area).permit(:name)
  end



  end
