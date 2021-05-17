class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = %w[Y Z D U Q E Z Y Q I]
  end

  def score
    @letters = params[:letters].split
    @reply = params[:reply]
    @check = check
  end

  private

  def filter_arr(word)
    word.upcase.split('').reject do |letter|
      if @letters.include?(letter)
        idx = @letters.index(letter)
        @letters.delete_at(idx)
      end
    end
  end

  def check
    if filter_arr(@reply).any?
      "Sorry but #{@reply} can't be built out of #{params[:letters]}."
    else
      url = "https://wagon-dictionary.herokuapp.com/#{@reply}"
      reply_serialized = URI.open(url).read
      english_word = JSON.parse(reply_serialized)
      exists = english_word['found']
      exists ? "Congratulations! #{@reply} is a valid English word!" :
      "Sorry but #{@reply} does not seem to be a valid English word..."
    end
  end
end
