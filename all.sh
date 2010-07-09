rvm ree
rake db:reset
rake app:fcenter > fcenter &
rake app:oldi > oldi &
rake app:almer > almer
rake app:citylink > city
rake ts:rebuild
rake app:cross > cross

