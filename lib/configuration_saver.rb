class ConfigurationSaver

  def self.save(record, config)
      saver = self.new(record, config)
      saver.save
  end

  def initialize(record_or_url, config)
    raise("Record can't be nil") if !record_or_url
    raise("Config can't be nil") if !config
    if record_or_url.is_a? String then
      @record = ScrapedConfiguration.new(:url => record_or_url)
    else
      @record = record_or_url
    end
    @config = config
  end

  def save
    build_configuration_lines()
    copy_config_to_record()
    @record.save
  end

  def build_configuration_lines()
    @config[:prices].each do |price|
      @record.configuration_lines.build(:price_id => price[:price].id, :quantity => 1, :price_value => price[:value])
    end
  end

  def copy_config_to_record()
    @record.name = @config.try(:[], :title)
    @record.total_price = @config.try(:[], :total_price)
    @record.assembly_price = @config.try(:[], :assembly_price)
    @record.company_id = @config[:company_id]
  end
end