# Recherche partir d'un nom
# 1 Retrouver fqID avec la methode search
# 2 avec FQID appelle la methode lockup

#1.  Mettre a jour ou creer une nouvelle plantae
#2. Trouver les images
#3 retrouver la classifactions , Especes Genre, famille
#4. Ajouter complementaires comme name_published_in_year
#powo_client.search
#powo_client.lookup

require "down"
require "taxa"
require "csv"
@powo_client = Taxa::PlantsOfTheWorldOnline::Client.new

def fetch_classification(classification, rank, taxon)
  p "============> fetch_classification"
  classification.each do |c|
    class_name = c["rank"].downcase.upcase_first
    next if class_name == rank
    class_object = Object.const_get(class_name)
    p "class_name #{class_name}"
    t = class_object.find_or_create_by(name: c['name'])
    t.fq_id = c["fqId"]
    t.authors = c["author"].split
    t.save!
  end
end

def fetch_extra_info(taxon, r)
  p "============> fetch_extra_info"
  taxon.update(source: r["source"],
           name_published_in_year: r["namePublishedInYear"],
           taxon_remarks: r["taxonRemarks"],
           locations: r["locations"].to_a,
           authors: r["source"],
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
    taxon.synonyms.find_or_create_by(synonymable_copy_id: t.id)
  end
end

def fetch_descriptions(descriptions, taxon)
  descriptions.to_a.each do |k,v|
    taxon.descriptionables.find_or_create_by(key: k, name: v["source"], from_synonym: v["fromSynonym"], descriptions: v["descriptions"])
  end
end

def fetch_ddistribution(distribution, taxon)
  distribution.to_a.each do |k,v|
    taxon.build_distributionable unless s.distributionable
    taxon.distributionable.update!("#{k}": v)
  end
end

# recupere les plantes
def fetch_data_species(genus, species)
  p "#{genus}-#{species}"
  r = @powo_client.search("genus:#{genus},species:#{species}" ,{'filters'=>['species_f']})
  r = r["results"][0]
  #create basic relation
  s = Species.find_or_create_by(fq_id: r['fqId'], name: r['name'])
  g = Genus.find_or_create_by(name: r['name'].split[0])
  f = Family.find_or_create_by(name: r['family'])
  s.update!(genus: g)
  g.update!(family: f)

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
end

def fetch_data_genus(genus)
  r = @powo_client.search("genus:#{genus.name}" ,{'filters'=>['genus_f']})
  r = r["results"][0]
  genus.update(fq_id: r['fqId'])
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

###########
### importa data from CSV
####



task :import_csv   do
end
