require "ap"
namespace :app do

  desc "find most used words"
  task :words => :environment do
    words = {}
    reversed_words = {}
    word_count = [1,2,3,4,5,6]
    word_count.each { |count| words[count] = Hash.new(0); reversed_words[count] = Hash.new(0) }


    Price.find_each do |price|
      word_count.each do |count|
        word = price.original_description.split[0,count].join(" ")
        words[count][word]+=1
        reversed_word = price.original_description.split.reverse[0, count].join(" ")
        reversed_words[count][reversed_word]+=1
      end
    end

    word_count.each { |count| words[count] = words[count].map(&:to_a).sort {|a,b| b[1] <=> a[1]} }
    word_count.each { |count| words[count] = words[count][0,200] }

    word_count.each { |count| reversed_words[count] = reversed_words[count].map(&:to_a).sort {|a,b| b[1] <=> a[1]} }
    word_count.each { |count| reversed_words[count] = reversed_words[count][0,30] }


    open('new_words', "w") do |file|
      word_count.each do |w|
        file << "words[#{w}] = [ \n"
        words[w].each { |word| file << "- \"#{word[0].mb_chars.downcase.gsub(/\"/, '\"')}\"\n" }
        file << "] \n"
      end
      file << "=" * 75 << "\n"
      word_count.each do |w|
        file << "reversed_words[#{w}] = [ \n"
        reversed_words[w].each { |word| file << "'#{word[0]}' ,\n" }
        file << "] \n"
      end
    end
  end
end

