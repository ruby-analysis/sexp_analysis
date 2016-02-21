module FileTree
  class Relation < Struct.new(:start_path, :finish_path)
    def other_files
      RelatedPaths.new(start_path).files
    end

    def other_directories
      RelatedPaths.new(start_path).directories
    end

    def distance
      if start_path.file? && finish_path.file?
        return traversed_files.length
      end

      if start_path.directory? && finish_path.directory?
        return  traversed_directories.length
      end

      traversed_files.length + traversed_directories.length
    end

    def possible_length
      other_files.length + other_directories.length
    end

    def traversed_files
      start_at_end = (start_path.file? && finish_path.directory?)

      subset_to_traverse(other_files, start_path, finish_path, start_at_end: start_at_end)
    end

    def traversed_directories
      start_at_end = (start_path.file? && finish_path.directory?) || (start_path.directory? && finish_path.file?)

      subset_to_traverse other_directories, start_path, finish_path, start_at_end: start_at_end
    end

    def subset_to_traverse(collection, start, finish, start_at_end: true)
      start_index  = collection.index start
      finish_index = collection.index finish

      if start_index.nil?
        start_index =  start_at_end ?  collection.length - 1 : 0
      end

      if finish_index.nil?
        finish_index =  start_at_end ?   0 : collection.length - 1
      end

      if start_index.zero? && finish_index.zero?
        finish_index = collection.length - 1
      end

      if start_index > finish_index
        start_index, finish_index = finish_index, start_index
      end

      collection[start_index..finish_index]
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

  class ChildFile        < Relation
    def other_files
      RelatedPaths.new(start_path + "*").files
    end

    def other_directories
      RelatedPaths.new(start_path + "*").directories
    end
  end
end
