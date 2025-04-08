# frozen_string_literal: true

require_relative 'dictionary'
require_relative 'gameboard'
require_relative 'messages'
require_relative 'validation'

# Hangman Class
# Controls logic and flow
class Hangman
  PATTERN_PUNCTUATION = /[[:punct:]|[:space:]]/.freeze
  PATTERN_ALPHA_NUMERIC = /[[:alpha:][:digit:]]/.freeze
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
    @tmp_secret_word = "Here T'was the night 'fore x-mas, ha!"
    @user_letter_guess = nil
    @missed_letters = []
    @gameboard = Gameboard.new(@tmp_secret_word.length)
    add_punctuation(@gameboard)
  end

  def add_punctuation(gameboard)
    gameboard.grid.each_with_index do |_cell, index|
      # Gameboard#update_board expects the second argument to be an array (even for a single letter)
      gameboard.update_board(index, [@tmp_secret_word[index]]) if PATTERN_PUNCTUATION.match?(@tmp_secret_word[index])
    end
  end

  def start
    print_game_display
    prompt_letter_guess
    process_guess
    print_game_display
  end

  private

  def capital?(letter)
    letter == letter.upcase
  end

  def first_char(input)
    input.chars.first.downcase
  end

  def get_indexes_of(letter)
    indexes = []
    @tmp_secret_word.to_enum(:scan, /#{letter}/i).each do
      indexes << Regexp.last_match.begin(0)
    end
    indexes
  end

  def match_case(user_letter_array, index)
    letter = user_letter_array.first
    compare_letter = @tmp_secret_word[index]
    return user_letter_array unless capital?(compare_letter)

    [] << letter.upcase
  end

  def playable?(letter)
    !@gameboard.grid.include?(letter) && !@missed_letters.include?(letter) && @tmp_secret_word.include?(letter)
  end

  def player_progress
    @gameboard.grid
  end

  def print_game_display
    Messages.print_game_info(player_progress)
    # print player_progress
  end

  def process_guess
    # if user guess is in secret_word && not in grid place all characters at indexes
    letter = @user_letter_guess[0]
    if playable?(letter)
      reveal_letter_at_indexes(letter)
    else
      @missed_letters << letter
    end
  end

  def prompt_letter_guess
    input = Messages.prompt_letter_guess
    @user_letter_guess = Validation.validate_entry(first_char(input), PATTERN_ALPHA_NUMERIC)
    Messages.clear_screen
  end

  def reveal_letter_at_indexes(letter)
    letter_indexes = get_indexes_of(letter)
    letter_indexes.each do |target_index|
      @gameboard.update_board(target_index, match_case(@user_letter_guess, target_index))
    end
  end

  def secret_word
    @tmp_secret_word.chars
  end
end
