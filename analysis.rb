#puts "Number of files: #{files.count}"
require 'rubygems'
require 'active_support/all'
require "byebug"
require 'parser/current'
require 'stemmify'

Parser::Builders::Default.emit_lambda = true # opt-in to most recent AST format


class SexpSummary < Struct.new(:glob, :exclusions)
  def sorted
    contents.each do |words|
      words.each do |word|
        word_count.add(word)
      end
    end

    word_count.sort_by(&:last).reverse
  end

  private

  def word_count
    @word_count ||= WordCount.new
  end

  def contents
    @contents ||= FileSexp.new(glob, exclusions).contents
  end
end

class WordCount < Hash
  def add(word)
    self[word] ||= 0
    self[word] += 1
  end
end


class FileSexp < Struct.new(:glob, :exclusions)
  def contents
    files.lazy.map do |f|
      FileContents.new(f).strings
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

class FileContents < Struct.new(:filename)
  def strings
    flatten(parse(raw)).
      map(&:to_s).
      map{|s| format_word(s)}.
      flatten.
      reject{|w| w.length < 3 }.
      reject{|w| stop_words.include?(w)}.
      reject(&:blank?)
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

  def flatten(sexp)
    sexp.to_a.map{|s| s.respond_to?(:to_a) ? flatten(s) : s }.flatten
  end

  def stop_words
    @stop_words ||=
      begin
        stop_words = eval File.read("./stop_words")
        stop_words.map {|w| format_word(w)}.flatten
      end
  end

  def format_word(w)
    decodify(w).
      split(" ").
      map(&:stem)
  end

  def decodify(w)
    w.underscore.
      gsub("_", " ").
      gsub(/[^\w ]/, " ")
  end
end



