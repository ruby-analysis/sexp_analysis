module SexpAnalysis
  class Glob
    attr_reader :glob, :exclusions

    def initialize(glob, exclusions=nil)
      @glob, @exclusions = glob, exclusions
    end

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
end
