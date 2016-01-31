#!/usr/bin/env ruby
require 'rubygems'
require 'active_support/all'
require "byebug"
require 'parser/current'

Parser::Builders::Default.emit_lambda = true # opt-in to most recent AST format

def usage!
  puts "Usage #{__FILE__} <file_match> <exclusions>"
  puts "e.g."
  puts "#{__FILE__} app/**/*.rb app/views"

  exit 1
end

unless ARGV.length >= 1
  usage!
end

GLOB = ARGV[0]
EXCLUSIONS = ARGV[1]

def files
  @files ||=
    begin
      files = Dir.glob(GLOB)

      if EXCLUSIONS && EXCLUSIONS.length >= 0
        files.reject{|f| f =~ %r{#{Regexp.escape(EXCLUSIONS)}}}
      end

      files
    end
end

#puts "Number of files: #{files.count}"

class FileContents < Struct.new(:filename)
  def strings
    flatten(parse(raw)).map(&:to_s).
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

class WordBreakdown < Hash
  def add(word)
    self[word] ||= 0
    self[word] += 1
  end
end

contents = files.lazy.map do |f|
  FileContents.new(f).strings
end

breakdown = WordBreakdown.new

result = contents.each.with_index do |words, i|
  #puts "analysing #{i}"

  words.each do |word|
    breakdown.add(word)
  end
end

sorted = breakdown.sort_by(&:last).reverse

sorted.each do |w,c|
  $stdout.puts "#{c}\t#{w}\n"
end
