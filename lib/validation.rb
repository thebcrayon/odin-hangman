# frozen_string_literal: true

# Module: Validation
# Handles input validation for Mastermind.
# Ensures user entries and board moves are valid before processing.
module Validation
  class << self
    def validate_entry(user_guess, match_pattern)
      loop do
        return format_entry(user_guess) if valid_entry?(user_guess, match_pattern)

        user_guess = Messages.error_invalid_entry
      end
    end

    private

    def alpha_numeric?(input, pattern)
      pattern.match?(input)
    end

    def format_entry(input)
      [input]
    end

    def secret_contains?(input, secret_word)
      secret_word.match?(/#{input}/i)
    end

    def valid_entry?(user_guess, match_pattern)
      # single alphabe numeric character
      alpha_numeric?(user_guess, match_pattern)
    end
  end
end
