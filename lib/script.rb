require 'csv'
require 'pry-byebug'

class Game
  def initialize(csv)
    @word_list = CSV.read(csv)
    @hangman_word = random_word_selector
    @incorrect_guesses = 0
    @incorrect_letters = []
    @display_word = initalize_display_word
    @guess_letter = ''
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

  # draws the word hint with filled in letters that have been guessed
  # first draws underscores the length of the word
  # then checks the guess against the word and fills in the proper index, substituting the letter for the underscores
  # joins display word into a display string
  # outputs display string to terminal
  def draw_word_hint
    check_guess
    puts "display word = #{@display_word}"
    display = @display_word.join()
    puts display
  end

  def initalize_display_word
    i = 0
    word = []
    while i < @hangman_word.length
      word.push('_')
      i += 1
    end
    @display_word = word
  end

  # checks if the guess is present in valid letters
  # if present, fills in where it is present
  # else increment incorrect guesses and add letter to incorrect letters
  def check_guess
    valid_letters = @hangman_word.split("")
    puts "Valid letters = #{valid_letters}"
    if valid_letters.include? @guess_letter
      puts "Valid letters includes guess letter"
      valid_letters.each_with_index do |letter, idx|
        if @guess_letter == letter
          @display_word[idx] = @guess_letter
        end
      end
    else
      @incorrect_guesses += 1
      @incorrect_letters.push(@guess_letter)
    end
  end

  # gets the letter guess from the player, assigns it to guess letter
  def get_guess
    puts "Guess a letter!"
    @guess_letter = gets.chomp
    puts "Guess letter = "
    p "#{@guess_letter}"
  end

  def display_incorrect_guesses
    guesses = @incorrect_letters.join()
    puts guesses
  end

  def play_game
    # draw board
    draw_game_board
    # draw ____ of letters for random word
    draw_word_hint
    # list guessed letters
    display_incorrect_guesses
    get_guess
    check_conditions
  end

  def check_conditions
    if @display_word.join("") == @hangman_word
      puts "You win!"
    elsif @incorrect_guesses == 6
      puts "You lose!"
    else
      play_game
    end
  end

  def save_game

  end

  def testing
    play_game
  end
end

csv = 'hangman_words.csv'
hangman_game = Game.new(csv)
hangman_game.testing