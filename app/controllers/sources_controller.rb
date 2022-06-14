class SourcesController < ApplicationController
  def
    index
    @sources = Source.ordered
    @source = Source.new
  end

  def new
    @source = Source.new
    @author = @source.people.build
  end

  def create
    @source = Source.new(source_params)
    respond_to do |format|
      if @source.save
        format.html { redirect_to sources_url, notice: "Source was successfully created" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy
    respond_to do |format|
     format.html { redirect_to sources_url, notice: "Source was successfully deleted." }
     format.turbo_stream
   end
  end

  def show
    @source = Source.find(params[:id])
  end

  def edit
    @source = Source.find(params[:id])
  end

  def update
    @source = Source.find(params[:id])
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to sources_url, notice: "source was successfully updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
  def source_params
    params.require(:source).permit(:title, :publication_date, :edition_reference, :web_link, :category, :origin, :note, person_ids:[], people_attributes: [:first_name, :last_name], plant_ids:[], plants_attributes: [:scientific, :pharmacopoeia, :family], area_ids:[], areas_attributes: [:name], name_ids:[], names_attributes: [:label, :category] )
  end
end
