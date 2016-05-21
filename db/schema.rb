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

ActiveRecord::Schema.define(version: 20160521184459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "artists", force: true do |t|
    t.string   "slug",                                     null: false
    t.string   "name",                                     null: false
    t.text     "description",                              null: false
    t.string   "sort_name",                                null: false
    t.string   "first_letter",      limit: 1,              null: false
    t.integer  "legacy_ids",                  default: [], null: false, array: true
    t.string   "facebook_page"
    t.string   "twitter_widget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail"
    t.string   "banner"
    t.integer  "banner_width"
    t.integer  "banner_height"
    t.integer  "view_count",                  default: 0,  null: false
    t.text     "playlist_embed"
  end

  add_index "artists", ["name"], name: "index_artists_on_name", unique: true, using: :btree
  add_index "artists", ["slug"], name: "index_artists_on_slug", unique: true, using: :btree
  add_index "artists", ["sort_name"], name: "index_artists_on_sort_name", using: :btree

  create_table "artists_genres", id: false, force: true do |t|
    t.integer "artist_id", null: false
    t.integer "genre_id",  null: false
  end

  create_table "artists_instruments", id: false, force: true do |t|
    t.integer "artist_id",     null: false
    t.integer "instrument_id", null: false
  end

  add_index "artists_instruments", ["artist_id", "instrument_id"], name: "unique_artists_instruments", unique: true, using: :btree

  create_table "auth_providers", force: true do |t|
    t.string   "key",        null: false
    t.string   "name",       null: false
    t.string   "token"
    t.string   "user_id"
    t.string   "user_name"
    t.datetime "synced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_providers", ["key"], name: "index_auth_providers_on_key", unique: true, using: :btree

  create_table "band_members", force: true do |t|
    t.integer  "song_id",     null: false
    t.string   "artist_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "band_members", ["song_id"], name: "index_band_members_on_song_id", using: :btree

  create_table "band_members_instruments", id: false, force: true do |t|
    t.integer "band_member_id", null: false
    t.integer "instrument_id",  null: false
  end

  add_index "band_members_instruments", ["band_member_id", "instrument_id"], name: "unique_band_members_instruments", unique: true, using: :btree

  create_table "contact_messages", force: true do |t|
    t.string   "email",      null: false
    t.string   "name",       null: false
    t.text     "message",    null: false
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "artist_id",                   null: false
    t.date     "date",                        null: false
    t.string   "type",                        null: false
    t.string   "slug",                        null: false
    t.text     "description",                 null: false
    t.boolean  "visible",     default: false, null: false
    t.text     "factsheet"
    t.integer  "legacy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "debuts_at"
    t.integer  "sort_order",  default: 0,     null: false
  end

  add_index "events", ["artist_id"], name: "index_events_on_artist_id", using: :btree
  add_index "events", ["date", "type"], name: "index_events_on_date_and_type", unique: true, using: :btree
  add_index "events", ["debuts_at"], name: "index_events_on_debuts_at", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree
  add_index "events", ["sort_order"], name: "index_events_on_sort_order", using: :btree

  create_table "features", force: true do |t|
    t.string  "title",                         null: false
    t.string  "url",                           null: false
    t.integer "priority",      default: 0,     null: false
    t.text    "description",                   null: false
    t.string  "banner",                        null: false
    t.integer "banner_width",                  null: false
    t.integer "banner_height",                 null: false
    t.boolean "enabled",       default: false, null: false
  end

  add_index "features", ["enabled", "priority"], name: "index_features_on_enabled_and_priority", using: :btree

  create_table "gallery_images", force: true do |t|
    t.integer  "artist_id",                  null: false
    t.string   "image",                      null: false
    t.integer  "width",      default: 0,     null: false
    t.integer  "height",     default: 0,     null: false
    t.integer  "position",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fixed",      default: false, null: false
  end

  add_index "gallery_images", ["artist_id", "position"], name: "index_gallery_images_on_artist_id_and_position", unique: true, using: :btree

  create_table "genres", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["name"], name: "index_genres_on_name", unique: true, using: :btree

  create_table "genres_search_results", id: false, force: true do |t|
    t.integer "search_result_id", null: false
    t.integer "genre_id",         null: false
  end

  add_index "genres_search_results", ["genre_id", "search_result_id"], name: "unique_genres_search_results", unique: true, using: :btree

  create_table "genres_songs", id: false, force: true do |t|
    t.integer "genre_id", null: false
    t.integer "song_id",  null: false
  end

  add_index "genres_songs", ["genre_id", "song_id"], name: "index_genres_songs_on_genre_id_and_song_id", unique: true, using: :btree

  create_table "instruments", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instruments", ["name"], name: "index_instruments_on_name", unique: true, using: :btree

  create_table "instruments_search_results", id: false, force: true do |t|
    t.integer "search_result_id", null: false
    t.integer "instrument_id",    null: false
  end

  add_index "instruments_search_results", ["instrument_id", "search_result_id"], name: "unique_instruments_search_results", unique: true, using: :btree

  create_table "live_transmission_settings", force: true do |t|
    t.time     "starts_at",  null: false
    t.time     "ends_at",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "live_transmissions", force: true do |t|
    t.date     "date",         null: false
    t.integer  "artist_id",    null: false
    t.text     "description",  null: false
    t.text     "band_members"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "live_video"
  end

  add_index "live_transmissions", ["date"], name: "index_live_transmissions_on_date", using: :btree

  create_table "pdf_schedules", force: true do |t|
    t.date     "available_date", null: false
    t.string   "file",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pdf_schedules", ["available_date"], name: "index_pdf_schedules_on_available_date", unique: true, using: :btree

  create_table "schedule_items", force: true do |t|
    t.date     "date",        null: false
    t.integer  "artist_id",   null: false
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedule_items", ["date"], name: "index_schedule_items_on_date", using: :btree

  create_table "search_results", force: true do |t|
    t.integer  "searchable_id",   null: false
    t.string   "searchable_type", null: false
    t.string   "result_type",     null: false
    t.string   "title",           null: false
    t.text     "content",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_results", ["result_type"], name: "index_search_results_on_result_type", using: :btree

  create_table "songs", force: true do |t|
    t.integer  "playlistable_id",               null: false
    t.string   "playlistable_type",             null: false
    t.string   "title",                         null: false
    t.string   "composer",                      null: false
    t.integer  "position",          default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", force: true do |t|
    t.string   "name",                      null: false
    t.string   "email",                     null: false
    t.boolean  "enabled",    default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true, using: :btree

  create_table "timecodes", force: true do |t|
    t.integer  "video_id",    null: false
    t.integer  "seconds",     null: false
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timecodes", ["video_id", "seconds"], name: "index_timecodes_on_video_id_and_seconds", using: :btree

  create_table "tv_features", force: true do |t|
    t.datetime "debuts_at",   null: false
    t.integer  "show_id",     null: false
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tv_features", ["debuts_at"], name: "index_tv_features_on_debuts_at", using: :btree

  create_table "tv_schedule_items", force: true do |t|
    t.datetime "starts_at",   null: false
    t.string   "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tv_schedule_items", ["starts_at"], name: "index_tv_schedule_items_on_starts_at", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "viewable_id",                  null: false
    t.string   "viewable_type",                null: false
    t.string   "auth_user_id",                 null: false
    t.string   "youtube_id",                   null: false
    t.string   "title",                        null: false
    t.text     "description",                  null: false
    t.string   "tags",            default: [], null: false, array: true
    t.integer  "views",           default: 0,  null: false
    t.integer  "likes",           default: 0,  null: false
    t.integer  "dislikes",        default: 0,  null: false
    t.integer  "comments",        default: 0,  null: false
    t.string   "small_thumbnail"
    t.string   "large_thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["viewable_type", "viewable_id"], name: "index_videos_on_viewable_type_and_viewable_id", using: :btree
  add_index "videos", ["youtube_id"], name: "index_videos_on_youtube_id", unique: true, using: :btree

end
