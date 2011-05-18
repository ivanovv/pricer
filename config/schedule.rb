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

every 1.day, :at => '4:30 am' do
  command "#{path}/dl.sh"
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

every 1.day, :at => '5:30 am' do
  rake "app:almer"
end

every 1.day, :at => '5:40 am' do
  rake "app:all"
end


every 1.day, :at => '5:35 am' do
  rake "thinking_sphinx:index"
end

