#encoding: utf-8
require 'spec_helper'

describe BlackListChecker do
  let!(:site) { create :site }
  let!(:black_list_word) { create :black_list_word, lemma: "жоп" }
  let(:checker) { BlackListChecker.new }

  describe '#dirty?' do
    it 'is true for text with black list words' do
      checker.dirty?("Ну и жопа!").should be_truthy
    end

    it 'is false for text without black list words' do
      checker.dirty?("Хорошо живет на свете Винни Пух.").should be_falsey
    end

    it 'is false for empty string' do
      checker.dirty?("").should be_falsey
    end
  end
end
