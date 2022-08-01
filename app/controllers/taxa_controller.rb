class TaxaController < ApplicationController
  def index
    @taxa = {}
    page = 1
    powo_client = Taxa::PlantsOfTheWorldOnline::Client.new
    r = powo_client.search(params[:q],{'per_page' => 500, 'filters'=>['species_f','accepted_names']})
    @taxa = r["results"]
    respond_to do |format|
     format.html
     format.json {render :json => @taxa }
    end
  end
end
