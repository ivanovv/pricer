# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pricer_session',
  :secret      => '2fb2b02142f9b63e955431643f07ee9aed5f5016b8760bc8db5fef0fba17b9f609a1fd8ea34f15c8171d136d87b6876f448858086bea3e2ba2b2f18495c6a4c2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
