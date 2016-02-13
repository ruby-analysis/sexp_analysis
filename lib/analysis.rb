#puts "Number of files: #{files.count}"
require 'rubygems'
require 'active_support/core_ext/string'
require 'active_support/core_ext/object'
require "byebug"
require 'parser/current'

require 'stemmify'


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

class SexpStemmer < Struct.new(:filename)
  def stemmed_strings
    FileSexp.new(filename).
      flattened_sexp.
      map(&:to_s).
      map{|s| format_word(s)}.
      flatten.
      reject{|w| w.length < 3 }.
      reject{|w| stop_words.include?(w)}.
      reject(&:blank?)
  end

  private

  def format_word(w)
    decodify(w).
      split(" ").
      map(&:humanize).
      map(&:stem)
  end

  def decodify(w)
    w.underscore.
      gsub("_", " ").
      gsub(/[^\w ]/, " ")
  end

  def stop_words
    @@stop_words ||= define_stop_words
  end

  def define_stop_words
    stop_words = eval File.read("./stop_words")
    stop_words.map {|w| format_word(w)}.flatten
  end
end

class FileSexp < Struct.new(:filename)
  def flattened_sexp
    sexp_names.flatten
  end

  def sexp
    parse(raw)
  end

  def sexp_names
    to_a sexp
  end


  private

  def raw
    return unless filename[/\.rb$/]

    File.read(filename) unless File.directory?(filename)
  end

  def parser
    @parser ||= Parser::CurrentRuby
  end

  def parse(c)
    return [] if c.blank?
    parser.parse(c)
  end

  def to_a(sexp)
    sexp.to_a.map{|s| s.respond_to?(:to_a) ? to_a(s) : s }
  end
end



