# coding: utf-8
# Be sure to restart your server when you modify this file.
Menu::Application.configure do
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.session_store :cookie_store, :key    => '_menu_session',
    :secret => '86c4a81c7dbcc607a15b6ec2146649ef5c728bda4f049b068cca1a32a067cbb94dc3adb666e8a3a7b95cb0f4be515c533609c96a195c1a29d64405038a13810c'

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.session_store :active_record_store
end