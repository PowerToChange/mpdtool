# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081217201612) do

  create_table "mpd_contact_actions", :force => true do |t|
    t.integer  "mpd_contact_id"
    t.integer  "event_id"
    t.float    "gift_amount"
    t.boolean  "letter_sent",    :default => false
    t.boolean  "call_made",      :default => false
    t.boolean  "thankyou_sent",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mpd_contact_actions", ["mpd_contact_id", "event_id"], :name => "index_mpd_contact_actions_on_mpd_contact_id_and_event_id", :unique => true

  create_table "mpd_contacts", :force => true do |t|
    t.integer  "mpd_user_id"
    t.integer  "mpd_priority_id"
    t.string   "full_name",                     :default => "", :null => false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip",             :limit => 10
    t.string   "phone",           :limit => 15
    t.string   "email_address"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salutation"
  end

  add_index "mpd_contacts", ["mpd_priority_id"], :name => "mpd_contacts_mpd_priority_id_index"
  add_index "mpd_contacts", ["mpd_user_id"], :name => "mpd_contacts_mpd_user_id_index"

  create_table "mpd_events", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.integer  "cost"
    t.integer  "mpd_user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mpd_expense_types", :force => true do |t|
    t.string "name",                            :null => false
    t.float  "default_amount", :default => 0.0
  end

  create_table "mpd_expenses", :force => true do |t|
    t.integer "mpd_user_id"
    t.integer "mpd_expense_type_id"
    t.integer "amount",              :default => 0, :null => false
    t.integer "mpd_event_id"
  end

  add_index "mpd_expenses", ["mpd_expense_type_id"], :name => "mpd_expenses_mpd_expense_type_id_index"
  add_index "mpd_expenses", ["mpd_user_id"], :name => "mpd_expenses_mpd_user_id_index"

  create_table "mpd_letter_images", :force => true do |t|
    t.integer "mpd_letter_id", :null => false
    t.string  "image"
  end

  create_table "mpd_letter_templates", :force => true do |t|
    t.string  "name",                                 :null => false
    t.string  "thumbnail_filename",   :default => ""
    t.string  "pdf_preview_filename", :default => ""
    t.text    "description"
    t.integer "number_of_images",     :default => 0
  end

  create_table "mpd_letters", :force => true do |t|
    t.integer "mpd_letter_template_id"
    t.date    "date"
    t.string  "salutation",             :default => "Dear [[FULL_NAME]],"
    t.text    "update_section"
    t.text    "educate_section"
    t.text    "needs_section"
    t.text    "involve_section"
    t.text    "acknowledge_section"
    t.string  "closing",                :default => "Thank you,"
  end

  add_index "mpd_letters", ["mpd_letter_template_id"], :name => "mpd_letters_mpd_letter_template_id_index"

  create_table "mpd_priorities", :force => true do |t|
    t.integer  "mpd_user_id",                 :default => 0,  :null => false
    t.integer  "rateable_id",                 :default => 0,  :null => false
    t.integer  "priority",                    :default => 0
    t.datetime "created_at",                                  :null => false
    t.string   "rateable_type", :limit => 15, :default => "", :null => false
  end

  add_index "mpd_priorities", ["mpd_user_id"], :name => "fk_mpd_priorities_mpd_user"

  create_table "mpd_roles", :force => true do |t|
    t.string "name"
  end

  create_table "mpd_roles_users", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "mpd_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mpd_sessions", ["session_id"], :name => "index_mpd_sessions_on_session_id"
  add_index "mpd_sessions", ["updated_at"], :name => "index_mpd_sessions_on_updated_at"

  create_table "mpd_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mpd_letter_id"
    t.integer  "mpd_role_id"
    t.datetime "last_login"
    t.string   "type"
    t.boolean  "show_welcome",        :default => true
    t.boolean  "show_follow_up_help", :default => true
    t.boolean  "show_calculator",     :default => true
    t.boolean  "show_thank_help",     :default => true
    t.datetime "created_at"
    t.integer  "current_event_id"
  end

  add_index "mpd_users", ["mpd_letter_id"], :name => "mpd_users_mpd_letter_id_index"
  add_index "mpd_users", ["mpd_role_id"], :name => "mpd_users_mpd_role_id_index"
  add_index "mpd_users", ["user_id"], :name => "mpd_users_user_id_index"

end
