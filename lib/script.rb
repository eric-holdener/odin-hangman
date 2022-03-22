require 'csv'
require 'pry-byebug'

class Game
  def initialize(csv)
    @word_list = CSV.read(csv)
    @hangman_word = random_word_selector
    @incorrect_guesses = 0
  end

  def random_word_selector
    word_array = []
    @word_list.each do |word|
      word = word.join()
      if word.length >= 5 && word.length <= 12
        word_array.push(word)
      end
    end
    random_word = word_array[rand(0..word_array.length)]
  end

  def draw_game_board
    case @incorrect_guesses
      when 0
        puts ' ----|'
        puts ' |   |'
        puts '     |'
        puts '     |'
        puts '     |'
        puts '_____|'
      when 1
        puts ' ----|'
        puts ' |   |'
        puts ' o   |'
        puts '     |'
        puts '     |'
        puts '_____|'
      when 2
        puts ' ----|'
        puts ' |   |'
        puts ' o   |'
        puts ' |   |'
        puts '     |'
        puts '_____|'
      when 3
        puts ' ----|'
        puts ' |   |'
        puts ' o   |'
        puts '/|   |'
        puts '     |'
        puts '_____|'
      when 4
        puts ' ----|'
        puts ' |   |'
        puts ' o   |'
        puts '/|\  |'
        puts '     |'
        puts '_____|'
      when 5
        puts ' ----|'
        puts ' |   |'
        puts ' o   |'
        puts '/|\  |'
        puts '/    |'
        puts '_____|'
      when 6
        puts ' ----|'
        puts ' |   |'
        puts ' o   |'
        puts '/|\  |'
        puts '/ \  |'
        puts '_____|'
    end
  end

  def save_game

  end

  def testing
    i = 0
    while i < 7 do
      @incorrect_guesses = i
      draw_game_board
      i += 1
    end
  end
end

csv = 'hangman_words.csv'
hangman_game = Game.new(csv)
hangman_game.testing