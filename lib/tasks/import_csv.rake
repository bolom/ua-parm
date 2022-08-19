require "down"
require "taxa"
require "csv"
@powo_client = Taxa::PlantsOfTheWorldOnline::Client.new


task import_common_name_plants_csv: [:environment] do
  dataTable = CSV.table("#{Rails.root}/lib/tasks/plantes.csv")
  dataTable.each do |data|
    nui_plantes = data[:nui_plantes]
    nui_plantes = nui_plantes.remove "nui_pla_000"
    nui_plantes = nui_plantes.to_i
    p = Plant.find_by(nui_plant: nui_plantes.to_i)
    nom_vernaculaires = data[:nom_vernaculaire]
    nom_vernaculaires = nom_vernaculaires.split(",")
    nom_vernaculaires.each do |nom_vernaculaire|
      nom_vernaculaire = nom_vernaculaire.downcase.squish
      name = Name.find_or_create_by(label: nom_vernaculaire )
      p.names << name
    end
  end
end
task import_plants_csv: [:environment] do
  dataTable = CSV.table("#{Rails.root}/lib/tasks/plantes.csv")
  dataTable.each do |data|
    nom = data[:nom_scientifique]
    genus = nom.split[0]
    species = nom.split[1]
    nui_plantes = data[:nui_plantes]
    nui_plantes = nui_plantes.remove "nui_pla_000"
    nui_plantes = nui_plantes.to_i
    fetch_data_species(genus, species)
    s = Species.find_by(name: "#{genus} #{species}")
    g = s.genus
    f = g.family
    p = Plant.find_or_create_by(nui_plant: nui_plantes.to_i)
    pharmacope = data[:pharmacope]
    case pharmacope
    when "Ayurvédique/Indienne"
      pharmacope = "ayurveda"
    when "Française"
      pharmacope = "french"
    else
      pharmacope = "nothing"
    end
    pharmacope = pharmacope.downcase.to_sym
    p.update!(pharmacopoeia: pharmacope, genus: g, species: s, family: f)

    nom_vernaculaires = data[:nom_vernaculaire]
    nom_vernaculaires = nom_vernaculaires.split(",")
    nom_vernaculaires.each do |nom_vernaculaire|
      nom_vernaculaire = nom_vernaculaire.downcase.squish
      name = Name.find_or_create_by(label: nom_vernaculaire )
      p.names << name
    end
    end
end


# Ajouter attribut pratique dans le model citation
# rails g migration AddPratiqueCitation ( string)
# Ajouter attribut nui_source dans le model Source
# rails g migration AddNuiSourceCitation ( string)

# rake import_plants_csv # plantes csv
# rake import_biblio_csv # sources csv
# rake import_citations_csv # citations csv

task import_biblio_csv: [:environment] do
  dataTable = CSV.table("#{Rails.root}/lib/tasks/biblio.csv")
    dataTable.each do |biblio|
    source = Source.find_or_create_by(
      title: biblio[:ouvrage_titre],
      publication_date: biblio[:ouvrage_date_de_publication],
      edition_reference: biblio[:ouvrage_ref_ddition],
      web_link: biblio[:o_consulter_sur_le_web],
      category: biblio[:ref_type],
      origin: biblio[:ref_origine],
      note: biblio[:note],
      nui_source: biblio[:nuisources]

    )

    fetch_areas(source, biblio)
    # author
    fetch_authors(source, biblio[:auteur_nom_prnom_dates])
    # plants
    fetch_plants(source, biblio)
  end
end


# Ajouter attribut pratique dans le model citation
# Ajouter attribut nui_source dans le model Source

task import_citation_csv: [:environment] do
  puts "import_citation_csv"
  dataTable = CSV.table("#{Rails.root}/lib/tasks/citations.csv")
  dataTable.each do |biblio|
    # retrouver plant
    nui_plant = biblio[:lien_vers_nui_plantes]
    nui_plant = nui_plant.remove "nui_pla_000"
    plant = Plant.find_by!(nui_plant: nui_plant)

    genus = plant.name.split[0]
    species = plant.name.split[1]
    fetch_data_species(genus, species)
    # retrouver la Source
    nui_source = biblio[:lien_vers_nui_sources] #nui_sou_00001
    source = Source.find_by(nui_source: nui_source)
    citation = source.citations.find_or_initialize_by(text:biblio[:citation], page:biblio[:page], note:biblio[:note])
    citation.plant= plant
    citation.save!
    # creer les noms vernaculaires et lier a la plantes
    names = biblio[:noms_utiliss_dans_la_source]
    names.split(",").each do |name|
      n = Name.find_or_create_by(label: name)
      plant.names << n  # plants
      citation.names << n # sources
    end

    # Definir les pratiques
   utilizations = biblio[:types_de_pratique].split(",")
  #  p "utilizations #{utilizations}"
    utilizations.each do |utilization|
    #  p "utilization #{utilization}"
      u = Utilization.find_or_create_by(label: utilization.squish)
      citation.utilizations << u
    end

 end
end

####
task fill_up_missing_info_genera: [:environment] do
   Genus.all.each do |genus|
    fetch_data_genus( genus )
   end
end

task fill_up_missing_info_families: [:environment] do
  Family.all.each do |family|
    fetch_data_family(family)
  end
end

task fill_up_missing_info_species: [:environment] do
  Species.where(source: nil).each do |s|
    genus = s.name.split[0]
    species = s.name.split[1]
    fetch_data_species(genus, species)
  end
end


task update_synonyms_for_plants: [:environment] do
  Plant.all.each do |plant|
    ids = plant.species.synonyms.pluck(:synonymable_copy_id)
    plant.update(synonym_ids: ids )
  end
end

####################
def fetch_classification(classification, rank, taxon)
  p "============> fetch_classification"
  classification.each do |c|
    class_name = c["rank"].downcase.upcase_first
    if ["Subspecies","Variety","Unranked","Subvariety","Form"].include? class_name
      class_name = "Species"
    end
    class_object = Object.const_get(class_name)
    t = class_object.find_or_create_by!(name: c['name'])
    t.fq_id = c["fqId"]
    t.authors = c["author"].split
    t.save!
  end
end

def fetch_extra_info(taxon, r)
  p "============> fetch_extra_info"
  authors = []
  authors = r["authors"].split unless r["authors"].nil?
  taxon.update!(source: r["source"],
           name_published_in_year: r["namePublishedInYear"],
           taxon_remarks: r["taxonRemarks"],
           locations: r["locations"].to_a,
           authors: authors,
           synonym: r["synonym"],
           fungi: r["fungi"],
           plantae: r["plantae"],
           name: r["name"],
           nomenclatural_status: r["nomenclaturalStatus"],
           reference: r["reference"] )
end

# synonyms
def fetch_synonyms(synonyms, taxon)
  p "============> fetch_synonyms"
  synonyms.to_a.each do |c|
    #0 Retrouver le rank du Taxon
    class_name = c["rank"].downcase.upcase_first #Ex Species species
    if ["Subspecies","Variety","Unranked","Subvariety","Form"].include? class_name
      class_name = "Species"
    end
    class_object = Object.const_get(class_name)
    #1. Taxon find_or_create_by
    t = class_object.find_or_create_by(fq_id: c['fqId'])
    #2. name, author; taxonomicStatus
    author = c['author'].split
    t.update(name: c['name'], authors: author)

    case class_name
    when "Species"
      g = Genus.find_or_create_by(name: c['name'].split[0])
      t.genus = g
      t.save!
    when "Variety"
      t.species = taxon
      t.save!
    end
    s = taxon.synonyms.find_or_create_by!(synonymable_copy_id: t.id, synonymable_copy_type: class_name )
  end
end

def fetch_descriptions(descriptions, taxon)
  p "============> fetch_descriptions"
  descriptions.to_a.each do |k,v|
    taxon.descriptions.find_or_create_by(key: k, name: v["source"], from_synonym: v["fromSynonym"], descriptions: v["descriptions"])
  end
end

def fetch_distribution(distribution, taxon)
    distribution.to_a.each do |k,v|
    taxon.build_distribution unless taxon.distribution
    taxon.distribution.update!("#{k}": v)
  end
end

# recupere les plantes
def fetch_data_species(genus, species)
  p "#{genus} - #{species}"
  r = @powo_client.search("genus:#{genus},species:#{species}" ,{'filters'=>['species_f']})
  r = r["results"][0]
  #puts r
  #create basic relation
  s = Species.find_or_create_by(fq_id: r['fqId'], name: r['name'])
  p "Species #{s.id}"
  g = Genus.find_or_create_by(name: r['name'].split[0])
  f = Family.find_or_create_by(name: r['family'])
  s.update!(genus: g)
  g.update!(family: f)

  ######
  ## get images
  ####
  s.images.destroy_all
  images = r["images"]
  images.to_a.each do |image|
    image_url = "https:#{image["fullsize"]}"
    i = Down.download(image_url)
    s.images.attach(io: i, filename: "image.jpg")
  end

  r = @powo_client.lookup(s.fq_id,"descriptions,distribution")

  ######
  ## get classifactions
  ####
  fetch_classification(r["classification"], "species", species)

  ######
  ## get extra information
  ####
  fetch_extra_info(s,r)

  ######
  ## get extra synonyms
  ####
  fetch_synonyms(r["synonyms"], s)

  ######
  ## get extra descriptions
  ####

  fetch_descriptions(r["descriptions"], s)
  ######
  ## get extra distribution
  ####
  fetch_distribution(r["distribution"], s)
end

def fetch_data_genus(genus)
  r = @powo_client.search("genus:#{genus.name}" ,{'filters'=>['genus_f']})
  return if  r["results"].nil?
  r = r["results"][0]
  genus.update!(fq_id: r['fqId'])
  r = @powo_client.lookup(genus.fq_id,"descriptions,distribution")
  family = Family.find_or_create_by(name: r["family"])
  genus.update!(family: family)
  fetch_classification(r["classification"], "genus", genus)
  fetch_extra_info(genus, r)
  fetch_synonyms(r["synonyms"], genus)
  fetch_descriptions(r["descriptions"], genus)
end

def fetch_data_family(family)
  r = @powo_client.search("family:#{family.name}", {'filters'=>['families_f']})
  r = r["results"][0]
  family.update(fq_id: r['fqId'])
  r = @powo_client.lookup(family.fq_id,"descriptions,distribution")
  p r["classification"]
  fetch_classification(r["classification"], "family", family)
  fetch_extra_info(family, r)
  fetch_synonyms(r["synonyms"], family)
end

###############################
##### CSV
#######

def fetch_plants(source, biblio)
  unless biblio[:plantes_recherches_n_daprs_le_nui_plante].nil?
    plants = biblio[:plantes_recherches_n_daprs_le_nui_plante]
    plants = plants.remove! "JPL"
    plants = plants.remove! "BR"
    plants = plants.remove! "DR"
    plants = plants.remove! "/"

    plants.strip! # espace ban
    plants.gsub! ';',',' # remplace ; ,

    if plants == "1 à 20"
      source.plants << Plant.find_by(nui_plant: 1)
      source.plants << Plant.find_by(nui_plant: 2)
      source.plants << Plant.find_by(nui_plant: 3)
      source.plants << Plant.find_by(nui_plant: 4)
      source.plants << Plant.find_by(nui_plant: 5)
      source.plants << Plant.find_by(nui_plant: 6)
      source.plants << Plant.find_by(nui_plant: 7)
      source.plants << Plant.find_by(nui_plant: 8)
      source.plants << Plant.find_by(nui_plant: 9)
      source.plants << Plant.find_by(nui_plant: 10)
      source.plants << Plant.find_by(nui_plant: 11)
      source.plants << Plant.find_by(nui_plant: 12)
      source.plants << Plant.find_by(nui_plant: 13)
      source.plants << Plant.find_by(nui_plant: 14)
      source.plants << Plant.find_by(nui_plant: 15)
      source.plants << Plant.find_by(nui_plant: 16)
      source.plants << Plant.find_by(nui_plant: 17)
      source.plants << Plant.find_by(nui_plant: 18)
      source.plants << Plant.find_by(nui_plant: 19)
      source.plants << Plant.find_by(nui_plant: 20)
    else
        plants.split(",").each do |nui_plant|
          nui_plant = nui_plant.gsub(/ /, "")
          nui_plant = nui_plant.to_i
          p = Plant.find_by(nui_plant: nui_plant)
          source.plants << p
        end
    end
  end
end

def fetch_areas(source, biblio)
  unless biblio[:espace_mtq_couvert].nil?
    a = Area.find_or_create_by(name: biblio[:espace_mtq_couvert]) # Martinique
    source.areas << a
  end

  # autres zones
  zones = biblio[:espace_nom_des_autres_espaces_couverts]
 # object n'est pas nil
  unless zones.nil?
    zones.gsub! ';',',' # remplace ; ,
    #toutes les zones
    zones.split(",").each do |zone|
      a = Area.find_or_create_by(name: zone)
      source.areas << a
    end

  end
end

def fetch_authors(source, authors)
  unless authors.nil?
    authors.split(";").each do |author|
     a = author.split("(")
     #puts "===== a #{a}"
     full_name = a[0].split(',')
     #p "Nom #{full_name[0].strip}"
     #p "Prenoms #{full_name[1].strip}"

     person = Person.find_or_create_by(last_name: full_name[0].strip.downcase , first_name: full_name[1].strip.downcase)

     source.people << person

     dates = a[1]
     next if dates.nil? # cas ou il y a pas de date ou ()
     dates.slice! ')' # supprimer ma )
     dates = dates.split("-")
     next if dates.empty? # date avec () mais vide
     p "date de naissance #{dates[0].strip}"  unless dates[0].nil?
     p "date de dcd #{dates[1].strip}" unless dates[1].nil?

     person.update(date_birth: dates[0].strip) unless dates[0].nil?
     person.update(date_dc: dates[1].strip) unless dates[1].nil?

   end
  end
end
