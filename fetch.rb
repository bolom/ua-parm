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


#iterate CSV
dataTable = CSV.table('/Users/cantacuzene/Desktop/DW/AvecBolo/ua-parm/plantes.csv')

dataTable[:nom_scientifique].each do |nom|
  genus = nom.split[0]
  species = nom.split[1]
  p "genus #{genus} species #{species}"
  fetch_data_in_pow(genus, species)
end



##############################################

# Source
# People ok
# person_source
# Plant_Source

#TO DO ajouter date naissance + date de deces dans
# le model people

dataTableBiblio = CSV.table('/Users/bolo/Documents/Code/UA/ua-parm/biblio.csv')

dataTableBiblio[:auteur_nom_prnom_dates].each do |biblio|
  # prenom
  # nom de Famille
  # date DCD
  # date de naissance

  # cherche tous les authors
   next unless biblio
   biblio.split(";").each do |author|
    a = author.split("(")
    #puts "===== a #{a}"
    full_name = a[0].split(',')
    #p "Nom #{full_name[0].strip}"
    #p "Prenoms #{full_name[1].strip}"

    person = Person.find_or_create_by(last_name: full_name[0].strip.downcase , first_name: full_name[1].strip.downcase)

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

dataTableBiblio[:title_publication_date_edition_reference_web_link_category_origine_note].each do |biblio|
#titre
#date de publication
#l'édition
#les web link
#catégories
#origines
#notes

 next unless biblio
 biblio.each do |title|


   Source = Source.find_or_create_by(title: )

dataTableCitation = CSV.table('/Users/cantacuzene/Desktop/DW/AvecBolo/ua-parm/citation.csv')

  dataTableCitation[:noms_utiliss_dans_la_source].each do |citation|
#nom utilisé dans la source: Nom1, Nom2 - commence par une majuscule

#chercher tous les noms utilisés
  citation.split(",").each do |name|
    a= name.split (",")
    all_name= a[0].split(',')
    p "Nom #{all_name[0].strip}"

#name = Citation.create(name:all_name[0].strip)
  end

end

dataTableCitation[:types_de_pratique].each do |citation|
#pratique : médicinale, culturel, alimentaire, autre 

#chercher toutes les pratiques
citation.split(",").each do |pratique|
  a= pratique.split (",")
  all_pratique= a[0].split(',')
  p "Pratique #{all_pratique[0].strip}"
end

end
