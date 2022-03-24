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
    @round_incrementer = 0
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
    if valid_letters.include? @guess_letter
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
  end

  def display_incorrect_guesses
    guesses = @incorrect_letters.join()
    puts guesses
  end

  def play_game
    if @round_incrementer == 0
      draw_game_board
      draw_word_hint
      display_incorrect_guesses
      get_guess
      check_guess
      @round_incrementer += 1
      check_conditions
  end

  def check_conditions
    if @display_word.join("") == @hangman_word
      puts "You win!"
      puts "The word was #{@hangman_word}"
    elsif @incorrect_guesses == 6
      puts "You lose!"
      puts "The word was #{@hangman_word}"
    else
      play_game
    end
  end

  def save_or_play
    puts 'Would you like to:'
    puts '1: Save'
    puts '2: Continue Playing'
    player_choice = gets.chomp
    case player_choice
    when '1'
      save_game
    when '2'
      play_game
    else
      puts 'Please enter a valid command'
      save_or_play
    end
  end

  def save_game
     if Dir.exist?('savegames')
      # print files in directory, choose to overwrite or make a new file
     else
      Dir.mkdir('savegames')
      # save the file
    end
  end

  def load_game
    if Dir.exist?('savegames')
      puts 'What game would you like to load?'
      # list all files with selector number
    else
      puts 'It seems like there are no save games. Starting a new game for you.'
      play_game
    end
  end

  def initialize_game
    puts 'Would you like to:'
    puts '1: Play a new game'
    puts '2: Load a previous save'
    player_choice = gets.chomp
    case player_choice
    when '1'
      play_game
    when '2'
      load_game
    else
      puts 'Please enter a valid command.'
      initialize_game
    end
  end
end

csv = 'hangman_words.csv'
hangman_game = Game.new(csv)
hangman_game.initialize_game
