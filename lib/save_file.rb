# frozen_string_literal: true

require_relative 'serializable'
require 'yaml'
require 'json'
require 'msgpack'
require 'fileutils'

# SaveFile Definition
#
class SaveFile
  include Serializable

  FILEDIR = './saves'
  FILENAME = 'hangman_save.yml'
  PATH_TO_FILE = File.join(FILEDIR, FILENAME)

  def self.load_from_file
    file_exists = File.exist?(PATH_TO_FILE)
    if file_exists
      string = File.read(PATH_TO_FILE)
      return from_yaml(string)
    end
    nil
  end

  def self.from_yaml(string)
    YAML.safe_load(string)
  end

  attr_reader :secret_word, :correct_guesses, :incorrect_guesses

  def initialize(data)
    @secret_word = data[:secret_word]
    @correct_guesses = data[:correct_guesses]
    @incorrect_guesses = data[:incorrect_guesses]
    @guess_limit = data[:guess_limit]
  end

  def to_h
    {
      'secret_word' => @secret_word,
      'correct_guesses' => @correct_guesses,
      'incorrect_guesses' => @incorrect_guesses,
      'guess_limit' => @guess_limit
    }
  end

  def save_file
    FileUtils.mkdir_p(FILEDIR)
    File.write(PATH_TO_FILE, to_yaml_format)
  end
end
