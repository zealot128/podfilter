# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140920175957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "fuzzystrmatch"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_podcasts", id: false, force: true do |t|
    t.integer "category_id"
    t.integer "podcast_id"
  end

  add_index "categories_podcasts", ["category_id", "podcast_id"], name: "categories_podcasts_index", unique: true, using: :btree

  create_table "change_requests", force: true do |t|
    t.string   "type"
    t.boolean  "completed"
    t.integer  "owner_id"
    t.hstore   "payload"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "change_requests", ["completed"], name: "index_change_requests_on_completed", using: :btree
  add_index "change_requests", ["owner_id"], name: "index_change_requests_on_owner_id", using: :btree
  add_index "change_requests", ["token"], name: "index_change_requests_on_token", using: :btree
  add_index "change_requests", ["type"], name: "index_change_requests_on_type", using: :btree

  create_table "duplicate_candidates", force: true do |t|
    t.integer "ids", array: true
    t.string  "md5"
  end

  add_index "duplicate_candidates", ["md5"], name: "index_duplicate_candidates_on_md5", unique: true, using: :btree

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "url"
    t.string   "image"
    t.datetime "pubdate"
    t.string   "guid"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "media_url"
  end

  add_index "episodes", ["created_at", "source_id"], name: "index_episodes_on_created_at_and_source_id", using: :btree
  add_index "episodes", ["created_at"], name: "index_episodes_on_created_at", using: :btree
  add_index "episodes", ["pubdate"], name: "index_episodes_on_pubdate", using: :btree
  add_index "episodes", ["source_id", "created_at"], name: "index_episodes_on_source_id_and_created_at", using: :btree
  add_index "episodes", ["source_id", "guid"], name: "episode_uniq_guid", unique: true, using: :btree
  add_index "episodes", ["source_id", "pubdate"], name: "index_episodes_on_source_id_and_pubdate", using: :btree
  add_index "episodes", ["source_id"], name: "index_episodes_on_source_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "owner_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["owner_id"], name: "index_identities_on_owner_id", using: :btree

  create_table "opml_files", force: true do |t|
    t.text     "source"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "md5"
    t.string   "name"
    t.string   "type"
  end

  add_index "opml_files", ["md5", "owner_id"], name: "index_opml_files_on_md5_and_owner_id", using: :btree
  add_index "opml_files", ["owner_id"], name: "index_opml_files_on_owner_id", using: :btree
  add_index "opml_files", ["type"], name: "index_opml_files_on_type", using: :btree

  create_table "opml_files_sources", id: false, force: true do |t|
    t.integer "opml_file_id"
    t.integer "source_id"
  end

  add_index "opml_files_sources", ["opml_file_id", "source_id"], name: "opml_files_sources_index", unique: true, using: :btree
  add_index "opml_files_sources", ["source_id"], name: "index_opml_files_sources_on_source_id", using: :btree

  create_table "owners", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "admin"
    t.integer  "primary_identity_id"
  end

  add_index "owners", ["primary_identity_id"], name: "index_owners_on_primary_identity_id", using: :btree
  add_index "owners", ["token"], name: "index_owners_on_token", unique: true, using: :btree

  create_table "podcasts", force: true do |t|
    t.text     "title"
    t.text     "description"
    t.string   "image"
    t.integer  "subscriber_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  create_table "recommendations", force: true do |t|
    t.integer "owner_id"
    t.integer "weight"
    t.integer "podcast_id"
  end

  add_index "recommendations", ["owner_id", "podcast_id"], name: "recommendations_owner_podcast", unique: true, using: :btree
  add_index "recommendations", ["weight"], name: "index_recommendations_on_weight", using: :btree

  create_table "sources", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "offline"
    t.boolean  "active"
    t.string   "ancestry"
    t.integer  "owners_count"
    t.integer  "podcast_id"
    t.boolean  "has_media"
  end

  add_index "sources", ["active"], name: "index_sources_on_active", using: :btree
  add_index "sources", ["ancestry"], name: "index_sources_on_ancestry", using: :btree
  add_index "sources", ["has_media"], name: "index_sources_on_has_media", using: :btree
  add_index "sources", ["offline"], name: "index_sources_on_offline", using: :btree
  add_index "sources", ["owners_count"], name: "index_sources_on_owners_count", using: :btree
  add_index "sources", ["podcast_id", "id"], name: "index_sources_on_podcast_id_and_id", using: :btree
  add_index "sources", ["podcast_id"], name: "index_sources_on_podcast_id", using: :btree
  add_index "sources", ["url"], name: "index_sources_on_url", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
