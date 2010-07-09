namespace :scrape do

  desc "Scrape CityLink config"
  task :citylink => :environment do
    agent = Mechanize.new
    page = agent.get('http://www.citilink.ru/login/')
    login_form = page.form('mainForm')
    login_form.login = 'xuily@yandex.ru'
    login_form.password = 'poplkl'
    page = agent.submit(login_form, login_form.buttons.first)
    #page = agent.get('http://www.citilink.ru/configurator/')
    page = agent.get('http://www.citilink.ru/configurator/q26549/')
    links = page.search('td h2')
    links.each {|l| puts l.text}
  end
end