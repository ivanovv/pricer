
set :output, "#{path}/log/cron_log.log"
job_type :rake, 'cd :path && RAILS_ENV=:environment bundle exec rake :task --silent :output'

every 1.day, :at => '4:30 am' do
  command "#{path}/dl.sh"
end

every 1.day, :at => '3:00 am' do
  rake 'app:update_vendor_code'
end

#every 1.day, :at => '5:00 am' do
#  rake "app:citylink"
#end

every 1.day, :at => '5:10 am' do
  rake 'app:fcenter'
end

every 1.day, :at => '5:20 am' do
  rake 'app:oldi'
end

#every 1.day, :at => '5:25 am' do
#  rake 'app:almer'
#end

every 1.day, :at => '5:30 am' do
  rake 'app:justcom'
end

every 1.day, :at => '5:35 am' do
  rake 'app:all'
end

every 40.minutes do
  rake 'app:spider company=CityLink'
end

every 10.minutes do
  rake 'app:spider company=Meijin'
end

every 1.hour do
  rake 'app:spider company=Oldi'
end

