#puts "Number of files: #{files.count}"
require 'rubygems'
require 'active_support/all'
require "byebug"
require 'parser/current'

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
      map{|s| humanize(s)}.
      reject{|w| stop_words.include?(w)}
  end

  private

  def raw
    File.read(filename)
  end

  def parser
    @parser ||= Parser::CurrentRuby
  end

  def parse(c)
    parser.parse(c)
  end

  def flatten(sexp)
    sexp.to_a.map{|s| s.respond_to?(:to_a) ? flatten(s) : s }.flatten
  end

  def stop_words
    @stop_words ||=
      begin
        words = eval File.read("./stop_words")
        words.map {|w| humanize(w)}
      end
  end

  def humanize(w)
    w.underscore.gsub(/_/, " ").humanize.gsub(/^@/, "")
  end
end



