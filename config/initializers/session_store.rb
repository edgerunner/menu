# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_menu_session',
  :secret      => '012931c5671e89f44620bca79249d48927f7e449e62eb955a4c27f39977a3b69ea60a12aee5474e5fba9b4138beff225642c975b5027946c6aac903e5e7d4b1f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
