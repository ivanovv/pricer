# encoding: UTF-8

class PriceDescriptionNormalizer

  RETAIL = [ 'retail>', '(retail)', 'ret', '(ret)' ]
  OEM = [ 'oem>', 'oem' ]

  WORDS = YAML.load_file 'words.yml'
  WORD_COUNT = [5,4,3,2,1]

  def self.normalize_description(desc)
    return desc.to_s unless desc.is_a?(String)
    desc = desc.dup.mb_chars.downcase.to_s

    ['мат. плата', 'материнская плата', 'мат.плата'].each {|mb| desc.sub!(/#{mb}\s(.+?)\s<.+?>/iu, "\\1")}
    desc.sub!(/(?:внешний\s)?жесткий диск(?:\s2.5")?\s\d+(?:\.\d)?\s?[gtгт][bб](?:\s2.5")?\s(.+)[<(][^>)]+[>)]/iu, "\\1")
    desc.sub!(/твердотельный накопитель ssd 2.5\" \d+ gb\s(.+)/ui, "\\1")
    desc.sub!(/накопитель ssd \d+гб 2.5"\s(.+)/ui, "\\1")

    WORD_COUNT.each do |count|
      should_break = false
      WORDS[count].each do |word|
        if (should_break = desc.starts_with?(word + " "))
          desc.sub!(word + " ", '')
          break
        end
      end
      break if should_break
    end

    #TODO use regex here
    desc_words = desc.split
    last_word = desc_words[-1,1].to_s
    if RETAIL.index(last_word)
      desc_words[-1,1] = 'retail'
      desc = desc_words.join(" ")
    end

    desc.sub( /(\d+)\.0 Gb\s/iu, "\\1гб " ).
         sub( /(\d+)\sGb\s/iu, "\\1гб " ).
         sub( /(\d+)tb\s/iu, "\\1тб " ).
         sub( /(\d+)gb\s/iu, "\\1гб " ).
         sub( /western digital/iu, "wd" ).
         strip
  end

end

