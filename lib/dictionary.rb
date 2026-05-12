# frozen_string_literal: true

# Dictionary Definition:
# - loads words from file
# - filters words by length
# - returns one random word
class Dictionary
  def initialize
    @word_list = File.readlines('txt/dictionary.txt')
                     .map(&:strip)
                     .select { |word| word.length.between?(5, 12) }
  end

  def random_word
    @word_list.sample
  end
end

# p Dictionary.new.random_word
