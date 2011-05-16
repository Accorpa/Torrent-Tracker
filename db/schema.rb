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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110516215350) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "feeds", :force => true do |t|
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "torrents", :force => true do |t|
    t.string   "title",                          :null => false
    t.string   "category"
    t.string   "link",                           :null => false
    t.text     "description"
    t.datetime "published",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "matched",     :default => false
    t.integer  "tracking_id"
    t.string   "filename"
    t.boolean  "copied",      :default => false
  end

  add_index "torrents", ["filename"], :name => "index_torrents_on_filename"
  add_index "torrents", ["tracking_id"], :name => "index_torrents_on_tracking_id"

  create_table "trackings", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "destination"
  end

end
