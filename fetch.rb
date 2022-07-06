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
name = "Pimenta dioica" # la plante
powo_client = Taxa::PlantsOfTheWorldOnline::Client.new

r = powo_client.search("genus:#{name.split.first},species:#{name.split.last}" ,{'filters'=>['species_f']})
r = r["results"][0]
s = Species.find_or_create_by(fq_id: r['fqId'])
images = r["images"]

images.each do |image|
  image_url = "https:#{image["fullsize"]}"
  p image_url #trace
  i = Down.download(image_url)
  s.images.attach(io: i, filename: "image.jpg")
end

#################
r = powo_client.lookup(s.fq_id,"descriptions,distribution")

r["classification"].each do |c|
  p c["rank"]
  class_name = c["rank"].downcase.upcase_first
  class_object = Object.const_get(class_name)
  t = class_object.find_or_create_by(fq_id: c['fqId'])
  t.update(name: c['name'], authors: c['author'])
end

#Genre
g = Genus.find_by(name: r["genus"])
#attache Espace au Genre
s.genus = g
s.save!

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
