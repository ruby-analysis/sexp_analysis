module FileTree
  class Relation < Struct.new(:start_path, :finish_path)
    def other_files
      RelatedPaths.new(start_path).files
    end

    def other_directories
      RelatedPaths.new(start_path).directories
    end

    def traversed_files
      index = other_files.index start_path
      other_files[0..index]
    end

    def traversed_directories
      index = other_directories.index finish_path
      other_directories[index..-1]
    end

    class RelatedPaths < Struct.new(:path)
      def files
        all.select(&:file?)
      end

      def directories
        all.select(&:directory?)
      end

      private

      def all
        Dir.glob(path.dirname + "*").map{|f| Pathname.new(f)}
      end
    end
  end

  class SiblingFile < Relation
    def self.any?(path)
      new(path).others.length > 0
    end
  end

  ChildFile        = Class.new Relation
  SiblingDirectory = Class.new Relation
  ChildDirectory   = Class.new Relation
  ParentDirectory  = Class.new Relation

  class SiblingFileThenDirectoryThenParentDirectory < Relation

  end
end
