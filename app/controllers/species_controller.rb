class SpeciesController < ApplicationController

  def show
    @species = Species.find(params[:id])
    @ksp = @species.descriptions.find_by(key: "KSP")

    @natives = []
    @introduced = []

    @image = ""
    @image = @species.images.first unless @species.images.empty?

    unless @species.distribution.blank?
      @species.distribution.natives.each do |n|
        @natives << n["name"]
     end

      @species.distribution.introduced.each do |n|
        @introduced << n["name"]
      end
    end

  end

end
