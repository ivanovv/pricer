# Use this file to easily define all of your cron jobs.

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end


set :output, "#{path}/log/cron_log.log"
job_type :rake, "cd :path && RAILS_ENV=:environment rvm use 1.9.3 do bundle exec rake :task --silent :output"

every 1.day, :at => '4:30 am' do
  command "#{path}/dl.sh"
end

every 1.day, :at => '3:00 am' do
  rake "app:update_vendor_code"
end

every 1.day, :at => '5:00 am' do
  rake "app:citylink"
end

every 1.day, :at => '5:10 am' do
  rake "app:fcenter"
end

every 1.day, :at => '5:20 am' do
  rake "app:oldi"
end

every 1.day, :at => '5:25 am' do
  rake "app:almer"
end

every 1.day, :at => '5:30 am' do
  rake "app:justcom"
end

every 1.day, :at => '5:35 am' do
  rake "app:all"
end

every 1.hour do
  rake "app:spider"
end

