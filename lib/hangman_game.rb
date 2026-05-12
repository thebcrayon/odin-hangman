# frozen_string_literal:true

# Hangman Game Definition:
# - owns secret word
# - owns correct guesses
# - owns incorrect guesses
# - knows whether won/lost/over
# - processes a guessed letter
class HangmanGame
  attr_reader :secret_word, :correct_guesses, :incorrect_guesses, :guess_limit

  def self.from_h(data)
    HangmanGame.new(
      secret_word: data['secret_word'],
      correct_guesses: data['correct_guesses'],
      incorrect_guesses: data['incorrect_guesses']
    )
  end

  def initialize(secret_word:, correct_guesses:, incorrect_guesses:)
    @secret_word = secret_word.downcase
    # @secret_word = 'zippybeet'
    @secret_word_chars = @secret_word.split('')
    @correct_guesses = correct_guesses
    @incorrect_guesses = incorrect_guesses
    @guess_limit = @secret_word.size / 2 + 3
  end

  def win?
    @secret_word_chars.all? { |letter| @correct_guesses.include?(letter) }
  end

  def lose?
    @incorrect_guesses.size >= @guess_limit &&
      !win?
  end

  def over?
    win? || lose?
  end

  def attempts_left
    @guess_limit - @incorrect_guesses.size
  end

  def to_h
    {
      secret_word: @secret_word,
      correct_guesses: @correct_guesses,
      incorrect_guesses: @incorrect_guesses,
      guess_limit: @guess_limit
    }
  end

  def process_guess(letter)
    already_guessed = @correct_guesses.include?(letter) || @incorrect_guesses.include?(letter)
    return :already_guessed if already_guessed

    if @secret_word_chars.include?(letter)
      @correct_guesses << letter
      :correct
    else
      @incorrect_guesses << letter
      :incorrect
    end
  end

  def display_word
    word_progress = @secret_word_chars.map do |letter|
      @correct_guesses.include?(letter) ? "#{letter} " : '_ '
    end

    word_progress.join
  end
end

# hg = HangmanGame.new
# hg.process_guess('z')
# hg.process_guess('p')
# hg.process_guess('l')
# hg.process_guess('e')
# hg.process_guess('t')
# hg.process_guess('b')
# hg.process_guess('p')
# hg.process_guess('i')
# p hg.correct_guesses
# p hg.incorrect_guesses
# p hg.win?
# p hg.remaining_guesses
# p hg.display_word
