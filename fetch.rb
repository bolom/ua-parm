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
@powo_client = Taxa::PlantsOfTheWorldOnline::Client.new

# recupere les plantes
def fetch_data_in_pow(genus, species)
  p "#{genus}-#{species}"
  r = @powo_client.search("genus:#{genus},species:#{species}" ,{'filters'=>['species_f']})
  r = r["results"][0]
  s = Species.find_or_create_by(fq_id: r['fqId'])
  g = Genus.find_or_create_by(name: r['genus'])
  s.genus = g
  s.save!


  images = r["images"]

  images.to_a.each do |image|
    image_url = "https:#{image["fullsize"]}"
    i = Down.download(image_url)
    s.images.attach(io: i, filename: "image.jpg")
  end
  #################
  r = @powo_client.lookup(s.fq_id,"descriptions,distribution")

  r["classification"].each do |c|
    p c["rank"]
    class_name = c["rank"].downcase.upcase_first
    class_object = Object.const_get(class_name)
    t = class_object.find_or_create_by(fq_id: c['fqId'])
    author = c['author'].split
    t.update(name: c['name'], authors: c['author'].split)
  end

  #Genre
  puts "S = #{s.id}"
  #g = Genus.find_by(name: r["genus"])
  #attache Espace au Genre


  #attache Famille au Genre
  f = Family.find_by(name: r["family"])
  g.family = f
  g.save!

  # Informations Complementaires
  s.update(source: r["source"],
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

  # Corriger le bug avec authors
  # descriptions
  # synonym


  r["synonyms"].to_a.each do |c|
    #0 Retrouver le rank du Taxon
    class_name = c["rank"].downcase.upcase_first #Ex Species species
    p "===> Synonyms #{class_name} #{s.id}"
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
    when class_name == "Species"
      t.genus = s.genus
      t.save!
    when class_name == "Variety"
      t.species = s
      t.save!
    end
    s.synonyms.find_or_create_by(synonymable_copy_id: t.id)
  end

  #descriptions
  r["descriptions"].to_a.each do |k,v|
    s.descriptionables.find_or_create_by(key: k, name: v["source"], from_synonym: v["fromSynonym"], descriptions: v["descriptions"])
  end

  #distributions
  r["distribution"].to_a.each do |k,v|
    s.build_distributionable unless s.distributionable
    s.distributionable.update!("#{k}": v)
  end
end


def fetch_plants_(source, biblio)
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
### iterate CSV
####

#sheets plants
dataTable = CSV.table('/Users/bolo/Documents/Code/UA/ua-parm/plantes.csv'
dataTable.each do |data|
  nom = data[:nom_scientifique]
  genus = nom.split[0]
  species = nom.split[1]
  nui_plantes = data[:nui_plantes]
  nui_plantes = nui_plantes.remove "nui_pla_000"
  s = Species.find_by(name: "#{genus} #{species}")
  nui_plantes = nui_plantes.to_i
  Plant.find_or_create_by!(nui_plant: nui_plantes.to_i, species_id:s.id )
  fetch_data_in_pow(genus, species)
end


#sheets sources
dataTableBiblio = CSV.table('/Users/bolo/Documents/Code/UA/ua-parm/biblio.csv')
dataTableBiblio.each do |biblio|
  source = Source.find_or_create_by(
    title: biblio[:ouvrage_titre],
    publication_date: biblio[:ouvrage_date_de_publication],
    edition_reference: biblio[:ouvrage_ref_ddition],
    web_link: biblio[:o_consulter_sur_le_web],
    category: biblio[:ref_type],
    origin: biblio[:ref_origine],
    note: biblio[:note]
  )

  fetch_areas(source, biblio)
  # author
  fetch_authors(source, biblio[:auteur_nom_prnom_dates])
  # plants
  fetch_plants_(source, biblio)
end

#sheets de citations
