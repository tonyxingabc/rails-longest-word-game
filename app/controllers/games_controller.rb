require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @input = params[:word].upcase
    @letters = params[:letters]
    if !api_validate(@input)
        @result = { score: 0, message: "API fail" }
    elsif !included?(@input, @letters)
      @result = { score: 0, message: "grid fail" }
    else
      score = @input.length * 10
      @result = { score: score, message: "pass" }
    end
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
  end

  def api_validate(attempt)
    # https://wagon-dictionary.herokuapp.com/word
    url = URI.parse("https://wagon-dictionary.herokuapp.com/#{attempt}")
    word_status = JSON.parse(open(url).read)
    return word_status["found"]
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

end
