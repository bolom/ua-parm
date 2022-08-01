module SpeciesHelper
  def url_plant_or_species(objet)
    if objet.plant.nil?
      species_path(objet)
    else
      plant_path(objet.plant)
    end
  end
end
