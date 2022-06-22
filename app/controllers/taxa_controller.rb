class TaxaController < ApplicationController
  def index
    @taxa = {}
    page = 1
    powo_client = Taxa::PlantsOfTheWorldOnline::Client.new
    r = powo_client.search(params[:q],{'filters'=>['species_f']})
    total_pages = r["totalPages"]
    @taxa = r["results"]
    respond_to do |format|
     format.html
     format.json {render :json => @taxa }
    end
  end
end
