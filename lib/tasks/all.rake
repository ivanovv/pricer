namespace :app do

  desc "Do all the stuff"
  task :all => :environment do
    Rake::Task["app:sync_items"].invoke
    Rake::Task["thinking_sphinx:index"].invoke
    Rake::Task["app:cross"].execute
    Rake::Task["app:cross_items"].execute
  end
end

