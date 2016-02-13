require 'stemmify'
require_relative 'file_sexp'

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


