class CitationsController < ApplicationController
  #before_action :find_citation

  def index
    @citations = Citation
      .by_source(params[:source])
      .by_utilization(params[:utilization])
      .by_name(params[:name])
      .by_plant(params[:plant])
      .ordered
  end

  def new
    @citation = Citation.new
  end

  def show
    @citation = Citation.find(params[:id])
    @plant = @citation.plant
  end

  def destroy
    @citation = Citation.find(params[:id])
    @citation.destroy
    redirect_to citations_url, notice: "Citation was successfully deleted."
  end

  def edit
    @citation = Citation.find(params[:id])
    @plant = @citation.plant
  end

  def create
    @citation = Citation.new(citation_params)
    respond_to do |format|
      if @citation.save!
        format.html { redirect_to citations_url, notice: "citation was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @citation = Citation.find(params[:id])
    respond_to do |format|
      if @citation.update(citation_params)
        format.html { redirect_to citations_url, notice: "citation was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
  def citation_params
    params.require(:citation).permit(:source_id,:plant_id, :text, :page, :note, utilization_ids:[], utilizations_attributes: [:label], name_ids:[], names_attributes: [:label])
  end

  def find_citation
    @citation = Citation.find(params[:id])
    @plant = @citation.plant
  end
end
