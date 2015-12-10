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

ActiveRecord::Schema.define(version: 20151205130121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "league_invitations", force: :cascade do |t|
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
    t.integer  "invitee_id"
    t.integer  "league_id"
  end

  add_index "league_invitations", ["invitee_id"], name: "index_league_invitations_on_invitee_id", using: :btree
  add_index "league_invitations", ["league_id"], name: "index_league_invitations_on_league_id", using: :btree
  add_index "league_invitations", ["user_id"], name: "index_league_invitations_on_user_id", using: :btree

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "owner_id"
    t.integer  "status",        default: 0
    t.datetime "starts_at"
    t.integer  "league_length"
    t.integer  "pause_length"
    t.integer  "target"
  end

  add_index "leagues", ["owner_id"], name: "index_leagues_on_owner_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "status",         default: 0
    t.datetime "starts_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "league_id"
    t.integer  "teamA_id"
    t.integer  "teamB_id"
    t.integer  "scoreA",         default: 0
    t.integer  "scoreB",         default: 0
    t.string   "imgurLink"
    t.decimal  "temperature",    default: 20.0
    t.string   "weather_string"
  end

  add_index "matches", ["league_id"], name: "index_matches_on_league_id", using: :btree
  add_index "matches", ["teamA_id"], name: "index_matches_on_teamA_id", using: :btree
  add_index "matches", ["teamB_id"], name: "index_matches_on_teamB_id", using: :btree

  create_table "partnerships", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
    t.integer  "partner_id"
    t.integer  "status",     default: 0
  end

  add_index "partnerships", ["partner_id"], name: "index_partnerships_on_partner_id", using: :btree
  add_index "partnerships", ["user_id"], name: "index_partnerships_on_user_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "talent"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "team_id"
    t.json     "face"
    t.integer  "fieldX",     default: 0
    t.integer  "fieldY",     default: 0
    t.float    "speed",      default: 10.0
    t.float    "stamina",    default: 10.0
    t.float    "fitness",    default: 10.0
    t.float    "goalkeep",   default: 10.0
    t.float    "defense",    default: 10.0
    t.float    "midfield",   default: 10.0
    t.float    "attack",     default: 10.0
    t.float    "strength",   default: 10.0
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "team_invitations", force: :cascade do |t|
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
    t.integer  "invitee_id"
    t.integer  "team_id"
  end

  add_index "team_invitations", ["invitee_id"], name: "index_team_invitations_on_invitee_id", using: :btree
  add_index "team_invitations", ["team_id"], name: "index_team_invitations_on_team_id", using: :btree
  add_index "team_invitations", ["user_id"], name: "index_team_invitations_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "strength"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "league_id"
    t.integer  "teamable_id"
    t.string   "teamable_type"
    t.integer  "points"
  end

  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "username"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.integer  "tokens",                       default: 0
  end

  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
