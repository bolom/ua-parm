class CitationsController < ApplicationController
  def index
    @citations = Citation.all
    @citation = Citation.new
  end

  def new
    @citation = Citation.new
  end
  def destroy
    @citation = Citation.find(params[:id])
    @citation.destroy
    redirect_to citations_url, notice: "Citation was successfully deleted."
  end

  def edit
    @citation = Citation.find(params[:id])
  end

  def create
    @citation = Citation.new(citation_params)
    respond_to do |format|
      if @citation.save
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
    params.require(:citation).permit(:source_id, :pratique, :text, :pages, :note, name_ids:[], names_attributes: [:label, :category])
  end



end
