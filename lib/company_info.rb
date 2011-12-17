#TODO Rewrite using belongs_to_company 'Oldi'
module CompanyInfo

  def company_name
      self.class::COMPANY_NAME
   end

   def company
      @company ||= Company.find_or_create_by_name company_name
   end

end