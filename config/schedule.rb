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


every 1.day, :at => '4:30 am' do
  command File.join(Rails.root, "dl.sh")
end

every 1.day, :at => '5:00 am' do
  command File.join(Rails.root,"all.sh")
end

every 1.day, :at => '6:00 am' do
rake "log:clear"
end

every 6.hours do
  rake "thinking_sphinx:index"
end

