# frozen_string_literal: true

require_relative 'hangman_game'
require_relative 'dictionary'
require_relative 'save_file'
require 'colorize'
# HangmanCLI Definition:
# - displays the game
# - asks for input
# - runs the loop
# - calls HangmanGame
class HangmanCLI
  def self.run
    user_selection = startup_prompt
    game = create_game(user_selection)
    HangmanCLI.new(game)
  end

  def self.startup_prompt
    menu
    loop do
      input = gets.chomp.to_i

      return input if input.between?(1, 2)

      puts 'Incorrect input, please try again...'
    end
  end

  def self.menu
    puts 'Please Select Option:'
    puts '1 = New Game'
    puts '2 = Continue Game'
  end

  def self.create_game(user_selection)
    user_selection == 1 ? clean_game : loaded_game
  end

  def self.loaded_game
    data = SaveFile.load_from_file
    unless data
      puts 'No saved game found. Starting a new game.'
      return clean_game
    end

    HangmanGame.from_h(data)
  end

  def self.clean_game
    HangmanGame.new(
      secret_word: Dictionary.new.random_word,
      correct_guesses: [],
      incorrect_guesses: []
    )
  end

  attr_reader :game

  def initialize(game)
    @game = game
    @quit = false
  end

  def play
    until @game.over? || @quit
      clear_screen
      display_info
      prompt_input
    end
    @game.over? ? show_results : quit_results
  end

  private

  def show_results
    clear_screen
    display_info
    print_win_loss
  end

  def print_win_loss
    if @game.win?
      puts 'You win'
    else
      puts "Sorry you lost. The word was #{@game.secret_word.colorize(:blue)}"
    end
  end

  def display_info
    puts
    puts "Hangman: Guess the word!\n\n"
    puts "#{@game.display_word}\n\n"
    puts "Correct guesses: #{correct_guesses}\n\n"
    puts "Incorrect guesses: #{incorrect_guesses}\n\n"
    puts "Attempts Left: #{attempts_left}\n\n"
  end

  def clear_screen
    print "\e[H\e[2J"
  end

  def prompt_input
    puts 'Enter letter or press 1 to save and exit:'
    loop do
      input = gets.chomp
      exit_option = input.to_i
      if exit_option == 1
        exit_game
        return
      end

      if single_char?(input)
        already_guessed = (@game.process_guess(input) == :already_guessed)
        return input unless already_guessed

        puts 'You have already used that letter, please try again.'
      end

      puts 'Incorrect input, please try again...' unless already_guessed
    end
  end

  def exit_game
    @quit = true
    save_and_quit
  end

  def quit_results
    puts 'Your game has been saved'
  end

  def save_and_quit
    # new savefile with current game data as hash
    sf = SaveFile.new(@game.to_h)
    sf.save_file
    # SaveFile object calls #save_file
    # show game saved message then full exit
  end

  def single_char?(input)
    input.match?(/([A-Za-z])/) && input.size == 1
  end

  def attempts_left
    @game.attempts_left
  end

  def correct_guesses
    @game.correct_guesses.join(', ')
  end

  def incorrect_guesses
    @game.incorrect_guesses.join(', ')
  end
end
