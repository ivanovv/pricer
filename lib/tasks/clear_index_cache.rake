desc "Clear Index Cache by Rake"
task :clear_index_cache => :environment do
  store = ActionController::Base.cache_store
  store.delete_matched(/index/)
end
