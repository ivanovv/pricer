
RAILS_ENV=production rake app:all > fcenter &
RAILS_ENV=production rake app:oldi > oldi &
RAILS_ENV=production rake app:almer > almer
RAILS_ENV=production rake app:citylink > city

RAILS_ENV=production rake app:all
