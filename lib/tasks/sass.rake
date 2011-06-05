namespace :sass do
  desc 'Updates stylesheets if necessary from their Sass templates.'
  task :update => :environment do
    sh "rm -rf tmp/sass-cache"
    Sass::Plugin.force_update_stylesheets
  end
end
