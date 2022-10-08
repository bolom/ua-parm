class ImagesController < ApplicationController
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: "image was successfully deleted."}
      format.turbo_stream
    end
  end

  def update
    @image = Image.find(params[:id])
    @image.insert_at(params[:position].to_i)
    head :ok
  end

  def create
    @species = Species.find(params[:species_id])
    image_size =   @species.images.count
    @image =   @species.images.new(image_params)
    @image.position = image_size + 1
    @image.save!
  end

  private
    def image_params
      params.require(:image).permit(:picture)
    end
end
