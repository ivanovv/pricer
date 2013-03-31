require 'rubygems'
require 'nokogiri'
require 'rest-client'

auth_token = "6ef670a6c1317e991448158070b3364a1d73ab59" # взять на страничке "My Settings" 
                          # https://your_account.airbrake.io/users/your_id/edit

project_id = 22357       # взять из урла в airbrake, иначе выводится 
                          # список ошибок из всех проектов

ids = (2..4).to_a.map { |page|
  Nokogiri::XML(RestClient.get "https://pricer.airbrake.io/errors.xml" +
      "?auth_token=#{auth_token}&page=#{page}&project_id=#{project_id}").
    search('group/id').map(&:text)
}.flatten

ids.each { |id|
  # чтобы не ждать, пока дофига запросов выполнится последовательно
    RestClient.put("https://pricer.airbrake.io/errors/#{id}?auth_token=#{auth_token}",
      :group => {:resolved => true})

}