namespace :app do

  desc "Do all the stuff"
  task :all => :environment do
    Rake::Task["ts:rebuild"].invoke
    Rake::Task["app:cross"].execute
    Rake::Task["app:cross_items"].execute
  end
end
