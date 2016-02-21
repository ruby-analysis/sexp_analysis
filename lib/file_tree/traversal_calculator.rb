require "pathname"
require_relative "relation"

module FileTree
  class TraversalCalculator
    def traversals_for(a, b)
      return handle_both_files(a,b) if a.file? && b.file?
      return handle_both_directories(a,b) if a.directory? && b.directory?
      return handle_file_and_directory(a,b) if a.file? && b.directory?
      return handle_directory_and_file(a,b) if a.directory? && b.file?

      raise NotImplementedError
    end

    class Internal < Struct.new(:a,:b)
      def same_directory?
        a.dirname == b.dirname
      end
    end

    def handle_both_files(a, b)
      if a.dirname == b.dirname
        return Relation
      end
      if (a + ".." == b)
        return Relation
      end

      if (b + ".." == a)
        return Relation
      end
    end

    def handle_file_and_directory(a, b)
      if a.dirname == b.dirname
        return Relation
      end

      if (a + ".." == b)
        return Relation
      end

      if (b + ".." == a)
        return Relation
      end
    end

    def handle_directory_and_file(a,b)
      if a.dirname == b.dirname
        return Relation
      end

      if (a + ".." == b)
        return Relation
      end

      if (b + ".." == a)
        return ChildFile
      end
    end

    def handle_both_directories(a,b)
      if a.dirname ==b.dirname
        return Relation
      end
      if (a + ".." == b)
        return Relation
      end

      if (b + ".." == a)
        return Relation
      end
    end
  end

end
