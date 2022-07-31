require "down"
require "taxa"
require "csv"
@powo_client = Taxa::PlantsOfTheWorldOnline::Client.new


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

  #nom vernaculaires

  nom_vernaculaires = data[:nom_vernaculaire]
  nom_vernaculaires = nom_vernaculaires.split(",")
  nom_vernaculaires.each do |nom_vernaculaire|
    p.names.find_or_create_by(label: nom_vernaculaire )
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
  puts dataTable
  dataTable.each do |biblio|
    # retrouver plant
    nui_plant = biblio[:lien_vers_nui_plantes] #nui_pla_00048
    puts nui_plant
    nui_plant = nui_plant.remove "nui_pla_000"
    nui_plant = nui_plant.to_i
    plant = Plant.find_by!(nui_plant: nui_plant)
    # retrouver la Source
    #puts dataTable[:lien_vers_nui_sources]
    nui_source = biblio[:lien_vers_nui_sources] #nui_sou_00001
    source = Source.find_by(nui_source: nui_source)
    # TO DO create la colums pratique
    # TO DO  diviser les citations dans la commun D \n

    puts plant.id

    citation = source.citations.find_or_initialize_by(pratique: biblio[:types_de_pratique], text: biblio[:citation], page:  biblio[:page], note:  biblio[:note])
    citation.plant= plant
    citation.save!
    # creer les noms vernaculaires et lier a la plantes
    names = biblio[:noms_utiliss_dans_la_source]
    p biblio
    names.split(",").each do |name|
      n = Name.find_or_create_by(label: name)
      plant.names << n  # plants
      citation.names << n # sources
    end
    # create la  citation

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
  Species.where(source: nil).each do |species|
    genus = species.name.split[0]
    species = species.name.split[1]
    fetch_data_species(genus, species)
  end
end

task fill_up_missing_info_sub_species: [:environment] do
  SubSpecies.all.each do |sub_species|
    r = @powo_client.lookup(sub_species.fq_id,"descriptions,distribution")
    species = Species.find_or_create_by(name: r["species"])
    sub_species.update!(species: species)
    fetch_classification(r["classification"], "subspecies", sub_species)
    fetch_extra_info(sub_species, r)
    fetch_synonyms(r["synonyms"], sub_species)
  end
end

task fill_up_missing_info_varieties: [:environment] do
  Variety.all.each do |variety|
    r = @powo_client.lookup(variety.fq_id,"descriptions,distribution")
    species = Species.find_by(name: r["species"])
    variety.update!(species: species, infraspecies: r["infraspecies"])
    fetch_classification(r["classification"], "variety", variety)
    fetch_extra_info(variety, r)
    fetch_synonyms(r["synonyms"], variety)
  end
end

task fill_up_missing_info_sub_varieties: [:environment] do
  Subvariety.all.each do |sub_variety|
    r = @powo_client.lookup(sub_variety.fq_id,"descriptions,distribution")
    species = Species.find_or_create_by(name: r["species"])
    sub_variety.update!(species: species, infraspecies: r["infraspecies"])
    fetch_classification(r["classification"], "subvariety", sub_variety)
    fetch_extra_info(sub_variety, r)
    fetch_synonyms(r["synonyms"], sub_variety)
  end
end

task fill_up_missing_info_unraked: [:environment] do
  UnRanked.all.each do |unraked|
    r = @powo_client.lookup(unraked.fq_id,"descriptions,distribution")
    fetch_classification(r["classification"], "unraked", unraked)
    fetch_extra_info(unraked, r)
    fetch_synonyms(r["synonyms"], unraked)
  end
end

task fill_up_missing_info_form: [:environment] do
  Form.all.each do |form|
    r = @powo_client.lookup(form.fq_id,"descriptions,distribution")
    species = Species.find_or_create_by(name: r["species"])
    form.update!(species: species, infraspecies: r["infraspecies"])
    fetch_classification(r["classification"], "form", form)
    fetch_extra_info(form, r)
    fetch_synonyms(r["synonyms"], form)
  end
end



####################
def fetch_classification(classification, rank, taxon)
  p "============> fetch_classification"
  classification.each do |c|
    class_name = c["rank"].downcase.upcase_first
    next if class_name == rank
    if class_name == "Unranked"
      class_name = "UnRanked"
    end

    if class_name == "Subspecies"
      class_name = "SubSpecies"
    end
    class_object = Object.const_get(class_name)
    p "class_name #{class_name}"
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
    if class_name == "Subspecies"
      class_name = "SubSpecies"
    end
    if class_name == "Unranked"
      class_name = "UnRanked"
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

    p " #{class_name} Taxon #{t.id}-#{taxon.id}"
    s=taxon.synonyms.find_or_create_by!(synonymable_copy_id: t.id, synonymable_copy_type: class_name )
    puts s.inspect
  end
end

def fetch_descriptions(descriptions, taxon)
  descriptions.to_a.each do |k,v|
    taxon.descriptionables.find_or_create_by(key: k, name: v["source"], from_synonym: v["fromSynonym"], descriptions: v["descriptions"])
  end
end

def fetch_distribution(distribution, taxon)
    distribution.to_a.each do |k,v|
    taxon.build_distributionable unless taxon.distributionable
    taxon.distributionable.update!("#{k}": v)
  end
end

# recupere les plantes
def fetch_data_species(genus, species)
  p "#{genus}-#{species}"
  r = @powo_client.search("genus:#{genus},species:#{species}" ,{'filters'=>['species_f']})
  r = r["results"][0]
  #puts r
  #create basic relation
  s = Species.find_or_create_by(fq_id: r['fqId'], name: r['name'])
  g = Genus.find_or_create_by(name: r['name'].split[0])
  f = Family.find_or_create_by(name: r['family'])
  s.update!(genus: g)
  g.update!(family: f)
  puts s.genus.family.name

  ######
  ## get images
  ####
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
  puts r
  fetch_distribution(r["distribution"], s)
end

def fetch_data_genus(genus)
  r = @powo_client.search("genus:#{genus.name}" ,{'filters'=>['genus_f']})
  return if  r["results"].nil?
  r = r["results"][0]
  genus.update!(fq_id: r['fqId'])
  r = @powo_client.lookup(genus.fq_id,"descriptions,distribution")
  family = Family.find_or_create_by(name: r["family"])
  p genus.id
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
