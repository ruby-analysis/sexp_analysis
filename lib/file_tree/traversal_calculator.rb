require "pathname"
require_relative "relation"

module FileTree
  class TraversalCalculator
    def traversals_for(a, b)
      return handle_directory_and_file(a,b) if a.directory? && b.file?
      handle_both_files(a, b)
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

    def handle_directory_and_file(a,b)
      return ChildFile if (b + ".." == a)

      Relation
    end
  end
end
