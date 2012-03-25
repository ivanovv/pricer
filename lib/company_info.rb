module CompanyInfo
  extend ActiveSupport::Concern

  included do
    class << self; attr_accessor :company_name;  end
  end

  module ClassMethods

    def belongs_to_company(company_name)
      @company_name = company_name
    end
  end

  def company_name
    self.class.company_name
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
  end

end