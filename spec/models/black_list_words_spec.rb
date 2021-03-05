# encoding : utf-8
require 'spec_helper'

describe BlackListWords do
  let(:words) { random_words }

  it 'initialized with attributes hash' do
    list = BlackListWords.new(words: words)
    list.words.should eq(words)
  end

  it 'craete bunch of BlackListWord' do
    list = BlackListWords.new(words: words)
    list.create_bunch
    BlackListWord.count.should eq(3)
  end

  def random_words(amount = 3)
    (1..amount).map do |i|
      letters = Array.new(rand(5) + 3) { ('а'..'я').to_a.sample }
      letters.join('')
    end.join(',')
  end
end
