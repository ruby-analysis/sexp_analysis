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

    def handle_both_files(a,b)
      if a.dirname == b.dirname
        return [SiblingFile]
      end
      if (a + ".." == b)
        return [SiblingFileThenDirectoryThenParentDirectory]
      end

      if (b + ".." == a)
        return [SiblingFileThenDirectory]
      end
    end

    def handle_file_and_directory(a,b)
      if a.dirname ==b.dirname
        return [SiblingFileThenDirectory]
      end

      if (a + ".." == b)
        return [SiblingFileThenDirectoryThenParentDirectory]
      end

      if (b + ".." == a)
        return [ChildDirectory]
      end
    end

    def handle_directory_and_file(a,b)
      if a.dirname ==b.dirname
        return [SiblingDirectoryThenFile ]
      end
      if (a + ".." == b)
        return [ParentDirectory]
      end

      if (b + ".." == a)
        return [ChildFile]
      end
    end

    def handle_both_directories(a,b)
      if a.dirname ==b.dirname
        return [SiblingDirectory]
      end
      if (a + ".." == b)
        return [SiblingDirectoryThenParentDirectory]
      end

      if (b + ".." == a)
        return [SiblingDirectoryThenChildDirectory]
      end
    end
  end

end
