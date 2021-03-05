# encoding: utf-8
require 'lingua/stemmer'

class BlackListWords
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :words

  validates :words, presence: true

  def initialize(attributes = {})
    @words = attributes[:words]
  end

  def persisted?
    false
  end

  def create_bunch
    lemmas = Lingua.stemmer(filtered_words, language: 'ru')

    lemmas.each do |lemma|
      BlackListWord.find_or_create_by_lemma(lemma)
    end
  end

  private
  # REFACTOR
  # move lemmatizer to its own class
  def filtered_words
    @words.split(/[\,;\s\r\n]+/).
      map { |w| w[/[а-яА-Я]*/] }.
      keep_if { |w| !w.blank? }.
      map { |w| w.mb_chars.downcase }
  end
end
