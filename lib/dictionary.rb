# frozen_string_literal: true

# Dictionary Class
class Dictionary
  def initialize(file_path)
    f = File.open(file_path).readlines.map do |line|
      line.scan(/\w+/)
    end
    @word_list = f.select { |word| word.size.between?(5, 12) }
  end
end
