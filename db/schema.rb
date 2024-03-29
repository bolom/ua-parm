# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_23_145648) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "area_sources", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_area_sources_on_area_id"
    t.index ["source_id"], name: "index_area_sources_on_source_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "citations", force: :cascade do |t|
    t.string "text"
    t.string "note"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "page"
    t.bigint "plant_id", null: false
    t.index ["plant_id"], name: "index_citations_on_plant_id"
    t.index ["source_id"], name: "index_citations_on_source_id"
  end

  create_table "citations_utilizations", force: :cascade do |t|
    t.bigint "citation_id", null: false
    t.bigint "utilization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["citation_id"], name: "index_citations_utilizations_on_citation_id"
    t.index ["utilization_id"], name: "index_citations_utilizations_on_utilization_id"
  end

  create_table "descriptions", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.boolean "from_synonym"
    t.jsonb "descriptions", default: "{}", null: false
    t.bigint "descriptionable_id"
    t.string "descriptionable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descriptions"], name: "index_descriptions_on_descriptions", using: :gin
  end

  create_table "distributions", force: :cascade do |t|
    t.jsonb "natives", default: "{}", null: false
    t.jsonb "introduced", default: "{}", null: false
    t.jsonb "doubtful", default: "{}", null: false
    t.bigint "distributionable_id"
    t.string "distributionable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.string "name_published_in_year"
    t.string "taxon_remarks"
    t.string "nomenclatural_status"
    t.string "locations", default: [], array: true
    t.string "authors", default: [], array: true
    t.boolean "synonym"
    t.boolean "plantae"
    t.boolean "fungi"
    t.string "fq_id"
    t.string "reference"
    t.string "taxonomic_status"
    t.string "nomenclatural_code"
    t.string "lifeform"
    t.string "climate"
    t.boolean "hybrid"
  end

  create_table "genera", force: :cascade do |t|
    t.bigint "family_id"
    t.string "source"
    t.integer "name_published_in_year"
    t.string "taxon_remarks"
    t.string "nomenclatural_status"
    t.string "locations", array: true
    t.string "authors", array: true
    t.boolean "synonym"
    t.boolean "plantae"
    t.boolean "fungi"
    t.string "fq_id"
    t.string "name"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "taxonomic_status"
    t.string "nomenclatural_code"
    t.string "lifeform"
    t.string "climate"
    t.boolean "hybrid"
    t.index ["family_id"], name: "index_genera_on_family_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable"
  end

  create_table "name_citations", force: :cascade do |t|
    t.bigint "citation_id", null: false
    t.bigint "name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["citation_id"], name: "index_name_citations_on_citation_id"
    t.index ["name_id"], name: "index_name_citations_on_name_id"
  end

  create_table "name_plants", force: :cascade do |t|
    t.bigint "plant_id"
    t.bigint "name_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_id"], name: "index_name_plants_on_name_id"
    t.index ["plant_id"], name: "index_name_plants_on_plant_id"
  end

  create_table "names", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_dc"
    t.string "date_birth"
  end

  create_table "person_sources", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_sources_on_person_id"
    t.index ["source_id"], name: "index_person_sources_on_source_id"
  end

  create_table "plant_sources", force: :cascade do |t|
    t.bigint "plant_id", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_plant_sources_on_plant_id"
    t.index ["source_id"], name: "index_plant_sources_on_source_id"
  end

  create_table "plants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pharmacopoeia"
    t.string "nui_plant"
    t.integer "species_id"
    t.integer "genus_id"
    t.integer "family_id"
    t.text "synonym_ids", default: [], array: true
    t.text "synonym_names", default: [], array: true
    t.index ["family_id"], name: "index_plants_on_family_id"
    t.index ["genus_id"], name: "index_plants_on_genus_id"
    t.index ["synonym_names"], name: "index_plants_on_synonym_names", using: :gin
  end

  create_table "sources", force: :cascade do |t|
    t.string "title"
    t.string "publication_date"
    t.string "edition_reference"
    t.string "web_link"
    t.string "category"
    t.string "origin"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nui_source"
  end

  create_table "species", force: :cascade do |t|
    t.bigint "genus_id"
    t.string "source"
    t.integer "name_published_in_year"
    t.string "taxon_remarks"
    t.string "nomenclatural_status"
    t.string "locations", array: true
    t.string "authors", array: true
    t.boolean "synonym"
    t.boolean "plantae"
    t.boolean "fungi"
    t.string "fq_id"
    t.string "name"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "taxonomic_status"
    t.string "nomenclatural_code"
    t.string "lifeform"
    t.string "climate"
    t.boolean "hybrid"
    t.index ["genus_id"], name: "index_species_on_genus_id"
  end

  create_table "synonyms", force: :cascade do |t|
    t.string "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "synonymable_id"
    t.bigint "synonymable_copy_id"
    t.string "synonymable_type"
    t.string "synonymable_copy_type"
    t.index ["synonymable_id", "synonymable_type"], name: "index_synonyms_on_synonymable_id_and_synonymable_type"
  end

  create_table "utilizations", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "area_sources", "areas"
  add_foreign_key "area_sources", "sources"
  add_foreign_key "citations", "plants"
  add_foreign_key "citations_utilizations", "citations"
  add_foreign_key "citations_utilizations", "utilizations"
  add_foreign_key "name_citations", "citations"
  add_foreign_key "name_citations", "names"
  add_foreign_key "person_sources", "people"
  add_foreign_key "person_sources", "sources"
  add_foreign_key "plant_sources", "plants"
  add_foreign_key "plant_sources", "sources"
end
