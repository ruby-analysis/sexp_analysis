require_relative 'sexp_stemmer'
require_relative 'glob'

module SexpAnalysis
  class AnalysisSummary

    attr_reader :glob, :exclusions

    def initialize(glob, exclusions=nil)
      @glob, @exclusions = glob, exclusions
    end

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
      @word_count ||= Counter.new
    end

    def files
      @files ||= Glob.new(glob, exclusions).files
    end
  end

  class Counter < Hash
    def add(*words)
      words.each do |word|
        self[word] ||= 0
        self[word] += 1
      end
    end
  end
end
