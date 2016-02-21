require_relative "distance_calculation"

module FileTree
  class FileTree
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def files
      @files ||= glob.
        select{|f| File.file?(f)}.
        map{|d| self.class.new(d) }
    end

    def directories
      @directories ||= glob.
        select{|f| File.directory?(f)}.
        map{|d| self.class.new(d) }
    end

    def distance_to(other)
      DistanceCalculation.new(self, other)
    end

    private

    def glob
      Dir.glob(path + "/*")
    end
  end
end
