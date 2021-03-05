#encoding: utf-8
require 'lingua/stemmer'

class BlackListChecker < Struct.new(:site)
  def check(object)
    object.dirty = dirty?(object.text)
    object.save! if object.changed?
  end

  def dirty?(text)
    BlackListWord.where(lemma: lemmas(text)).any?
  end

  private
  # TODO
  # make words extraction multi language
  def lemmas(text)
    words = text.split.
      map { |w| w[/[а-яА-Я]*/] }.
      keep_if { |w| !w.blank? }.
      map { |w| w.mb_chars.downcase }

    Lingua.stemmer(words, language: 'ru')
  end
end
