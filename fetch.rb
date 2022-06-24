r["classification"].each do |c|
  p c["rank"]
  class_name = c["rank"].downcase.upcase_first
  class_object = Object.const_get(class_name)
  t = class_object.find_or_create_by(fq_id: c['fqId'], name: c['name'], authors: [c['author']])
end

g = Genus.find_by(name: r["genus"])
s = g.species.find_or_create_by(fq_id: r['fqId'])
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

#Get images

r = powo_client.search("genus:#{s.name.split.first},species:#{s.name.split.last}" ,{'filters'=>['species_f']})
