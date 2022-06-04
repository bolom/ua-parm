class NamesController < ApplicationController
  def index
    @name = Name.new
    @names = Name.all
  end

  def create
    @name = Name.new(name_params)
    respond_to do |format|
      if @name.save
        format.html { redirect_to names_url, notice: "Name was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @name = Name.find(params[:id])
    @name.destroy
    redirect_to names_url, notice: "name was successfully deleted."
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
