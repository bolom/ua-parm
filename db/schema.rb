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

ActiveRecord::Schema[7.0].define(version: 2022_06_13_213217) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "pratique"
    t.string "text"
    t.string "pages"
    t.string "note"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "plants_id"
    t.bigint "name_id"
    t.index ["name_id"], name: "index_citations_on_name_id"
    t.index ["plants_id"], name: "index_citations_on_plants_id"
    t.index ["source_id"], name: "index_citations_on_source_id"
  end

  create_table "name_citations", force: :cascade do |t|
    t.bigint "citation_id", null: false
    t.bigint "name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["citation_id"], name: "index_name_citations_on_citation_id"
    t.index ["name_id"], name: "index_name_citations_on_name_id"
  end

  create_table "name_sources", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_id"], name: "index_name_sources_on_name_id"
    t.index ["source_id"], name: "index_name_sources_on_source_id"
  end

  create_table "names", force: :cascade do |t|
    t.string "label"
    t.string "category"
    t.bigint "plant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_names_on_plant_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "source_id", null: false
    t.bigint "plant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_plant_sources_on_plant_id"
    t.index ["source_id"], name: "index_plant_sources_on_source_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "family"
    t.string "pharmacopoeia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "scientific"
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
  end

  add_foreign_key "area_sources", "areas"
  add_foreign_key "area_sources", "sources"
  add_foreign_key "citations", "names"
  add_foreign_key "citations", "plants", column: "plants_id"
  add_foreign_key "name_citations", "citations"
  add_foreign_key "name_citations", "names"
  add_foreign_key "name_sources", "names"
  add_foreign_key "name_sources", "sources"
  add_foreign_key "person_sources", "people"
  add_foreign_key "person_sources", "sources"
  add_foreign_key "plant_sources", "plants"
  add_foreign_key "plant_sources", "sources"
end
