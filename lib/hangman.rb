# frozen_string_literal: true

require_relative 'dictionary'
require_relative 'gameboard'

# Hangman Class
# Controls logic and flow
class Hangman
end

word_list_directory = "#{Dir.pwd}/word-lists"
word_files_array = %w[generic bible]
file = "cat-#{word_files_array.sample}.txt"
file_path = File.join(word_list_directory, file)
d = Dictionary.new(file_path, [5, 12])

10.times do
  puts d.word_list.sample
end
