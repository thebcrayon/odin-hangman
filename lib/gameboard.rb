# frozen_string_literal: true

# Class: Gameboard
# Manages the state of the board and tracks what’s in each cell.
# Can check for a winning pattern or if the board is full.
# Doesn't care who's playing or what the rules are.
class Gameboard
  attr_accessor :grid

  def initialize(total_cells)
    @grid = Array.new(total_cells, nil)
  end

  def full?
    grid.all? { |value| !value.nil? }
  end

  def open?(idx)
    return true if @grid[idx].nil?

    false
  end

  def pattern_match?(winning_combinations)
    winning_combinations.any? do |combo|
      values = combo.map { |idx| @grid[idx] }
      values.uniq.length == 1 && !values.first.nil?
    end
  end

  def reset
    @grid = Array.new(9, nil)
  end

  def update_board(start_index, input)
    input.each.with_index(start_index) { |item, idx| grid[idx] = item }
  end
end
