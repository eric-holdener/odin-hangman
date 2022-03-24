require 'csv'
require 'json'
require 'pry-byebug'

class Game
  def initialize(csv)
    @hangman_word = random_word_selector(CSV.read(csv))
    @incorrect_guesses = 0
    @incorrect_letters = []
    @display_word = initalize_display_word
    @guess_letter = ''
    @round_incrementer = 0
  end

  def random_word_selector(csv)
    word_array = []
    csv.each do |word|
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
    @guess_letter = gets.chomp.downcase
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
    else
      draw_game_board
      draw_word_hint
      display_incorrect_guesses
      get_guess
      check_guess
      check_conditions
    end
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
    folder = 'savegames'
    if Dir.exist?(folder)
      # print files in directory, choose to overwrite or make a new file
      saves_array = Dir.entries(folder).sort[2..]
      saves_hash = {}
      saves_array.each_with_index do |filename, idx|
        saves_hash[idx] = filename
      end
      saves_hash[saves_hash.length] = 'New Save'
      puts 'Please select which save to overwrite / or new save.'
      saves_hash.each do |key, value|
        puts "#{key}: #{value}"
      end
      selection = gets.chomp
      if selection == saves_hash.length.to_s
        filename = "#{folder}/save_#{saves_hash.length}.json"
        contents = to_json
        File.open(filename, 'w') do |file|
          file.puts contents
        end
      elsif selection.to_i > saves_hash.length
        puts 'That doesn\'t seem to be a file!'
        save_game
      else
        filename = "#{folder}/save_#{selection}.json"
        contents = to_json
        File.open(filename, 'w') do |file|
          file.puts contents
        end
      end
    else
      Dir.mkdir(folder)
      filename = "#{folder}/save_0.json"
      contents = to_json
      File.open(filename, 'w') do |file|
        file.puts contents
      end
    end
  end

  def load_game
    folder = 'savegames'
    if Dir.exist?(folder)
      binding.pry
      puts 'What game would you like to load?'
      saves_array = Dir.entries(folder).sort[2..]
      saves_hash = {}
      saves_array.each_with_index do |filename, idx|
        saves_hash[idx] = filename
      end
      saves_hash.each do |key, value|
        puts "#{key}: #{value}"
      end
      selection = gets.chomp
      if selection.to_i >= saves_hash.length
        puts 'That doesn\'t seem to be a file!'
      else
        from_json!(File.read("#{folder}/save_#{selection}.json"))
        play_game
      end
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

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end

  def from_json!(string)
    JSON.parse(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end

  def test
    load_game
  end
end

csv = 'hangman_words.csv'
hangman_game = Game.new(csv)
hangman_game.test
