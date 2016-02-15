require "byebug"

require_relative 'sexp_stemmer'
require_relative 'glob'


class SexpSummary < Struct.new(:glob, :exclusions)
  def sorted
    sexp_contents.each do |words|
      word_count.add(*words)
    end

    word_count.sort_by(&:last).reverse
  end

  def sexp_contents
    @sexp_contents ||= files.lazy.map do |f|
      SexpStemmer.new(f).stemmed_strings
    end
  end

  private

  def word_count
    @word_count ||= WordCount.new
  end


  def files
    @files ||= Glob.new(glob, exclusions).files
  end
end

class WordCount < Hash
  def add(*words)
    words.each do |word|
      self[word] ||= 0
      self[word] += 1
    end
  end
end
