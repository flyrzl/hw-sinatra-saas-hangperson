class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    if letter == '' || letter == nil || /[^[a-zA-Z]]/.match(letter)
      raise ArgumentError
      return false
    end
    if @guesses.include?(letter) || @wrong_guesses.include?(letter) || /[[:upper:]]/.match(letter)
      return false
    end
    if @word.include? letter
      @guesses = @guesses + letter
      return true
    else
      @wrong_guesses = @wrong_guesses + letter
      return true
    end
  end

  def word_with_guesses
    @word_so_far = ''
    @word.each_char do |letter|
      if @guesses.include? letter
        @word_so_far = @word_so_far + letter
      else
        @word_so_far = @word_so_far + '-'
      end
    end
    return @word_so_far
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7
      return :lose
    end
    @word.each_char do |letter|
      if !@guesses.include? letter
        return :play
      end
    end
    return :win
  end

end
