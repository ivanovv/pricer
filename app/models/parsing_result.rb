# encoding: UTF-8

class ParsingResult < ActiveRecord::Base
  belongs_to :company

  scope :stats_for, lambda { |date| where("created_at BETWEEN ? and ?", date.beginning_of_day, date.end_of_day) }

  def self.today_stats
    self.stats_for(DateTime.now)
  end

  def to_s
    "#{company.name}:
    Всего строк: #{all_rows} Обработано строк: #{parsed_rows}
    Создано прайсов: #{created_rows} Обновлено цен: #{updated_rows}
    Начато: #{started_at.to_s(:short)} Завершено: #{finished_at.to_s(:short)}"
  end

end
