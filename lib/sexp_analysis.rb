require "sexp_analysis/version"
require "sexp_analysis/analysis_summary"
require "sexp_analysis/tree"

module SexpAnalysis
  class << self
    attr_accessor :logger

    def start!(*paths)
      require 'delfos'
      raise "Missing logger add e.g. SexpAnalysis.logger = Rails.logger to your initializer" unless logger
      Delfos.logger = logger
      Delfos::MethodLogging.logging_directories = paths.map{|p| Pathname.new(p) }
    end
  end

 # Your code goes here...
end
