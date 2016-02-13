#puts "Number of files: #{files.count}"
require 'rubygems'
require 'active_support/core_ext/string'
require "byebug"

require_relative 'sexp_stemmer'

Parser::Builders::Default.emit_lambda = true # opt-in to most recent AST format

class SexpSummary < Struct.new(:glob, :exclusions)
  def sorted
    sexp_contents.each do |words|
      word_count.add(*words)
    end

    word_count.sort_by(&:last).reverse
  end

  private

  def word_count
    @word_count ||= WordCount.new
  end

  def sexp_contents
    @sexp_contents ||= GlobSexp.new(glob, exclusions).contents
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


class GlobSexp < Struct.new(:glob, :exclusions)
  def contents
    files.lazy.map do |f|
      SexpStemmer.new(f).stemmed_strings
    end
  end

  private

  def files
    @files ||= determine_files
  end

  def determine_files
    files = Dir.glob(glob)

    if exclusions && exclusions.length >= 0
      files.reject{|f| f =~ %r{#{Regexp.escape(exclusions)}}}
    end

    files
  end
end


