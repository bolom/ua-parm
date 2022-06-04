class SourcesController < ApplicationController
  def
    index
    @sources = Source.all
    @source = Source.new
  end

  def create
    @source = Source.new(source_params)
    respond_to do |format|
      if @source.save
        format.html { redirect_to sources_url, notice: "Source was successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy
    redirect_to sources_url, notice: "source was successfully deleted."
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
    params.require(:source).permit(:title, :publication_date, :edition_reference, :web_link, :category, :origine, :note)
  end
end
