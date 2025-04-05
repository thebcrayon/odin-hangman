# frozen_string_literal: true

# Dictionary Class
class Dictionary
  attr_accessor :word_list

  def initialize(file_path, num_range = nil)
    words = File.readlines(file_path).map { |line| line.split("\n") }.flatten
    @word_list = words.select do |word|
      num_range ? word.size.between?(num_range.min, num_range.max) : word
    end
  end
end
