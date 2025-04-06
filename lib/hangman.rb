# frozen_string_literal: true

require_relative 'dictionary'
require_relative 'gameboard'
require_relative 'messages'

# Hangman Class
# Controls logic and flow
class Hangman
  def self.game_setup
    # prompt word length and save

    # prompt options for word theme
    word_list_directory = "#{Dir.pwd}/word-lists"
    word_files_array = %w[generic bible]
    file = "cat-#{word_files_array.sample}.txt"
    file_path = File.join(word_list_directory, file)

    # Instantiate new Dictionary with word them path and
    # word length
    Hangman.new(Dictionary.new(file_path, [5, 12]))
  end

  def self.play
    current_game = game_setup
    current_game.start
  end

  def initialize(dictionary)
    @secret_word = dictionary.current_word_list.sample
    @tmp_secret_word = "Don't doubt the Lord"
    new_board = Gameboard.new(@tmp_secret_word.length)
    @gameboard = add_punctuation(new_board)
  end

  def add_punctuation(board)
    punc_pattern = /[[:punct:]|[:space:]]/
    board.grid.map.with_index do |_cell, index|
      @tmp_secret_word[index] if punc_pattern.match?(@tmp_secret_word[index])
    end
  end

  def start
    print_game_display
  end

  private

  def player_progress
    @gameboard
  end

  def print_game_display
    Messages.print_game_info(player_progress)
    # print player_progress
  end

  def secret_word
    @tmp_secret_word.chars
  end
end
