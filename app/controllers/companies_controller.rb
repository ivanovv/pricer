# encoding: UTF-8
class CompaniesController < ApplicationController
  respond_to :json

   def index
     respond_with(Company.all)
   end
end
