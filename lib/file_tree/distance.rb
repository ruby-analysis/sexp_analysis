require_relative "traversal_calculator"

module FileTree
  class Distance < Struct.new(:path_a, :path_b)
    attr_reader :traversal_a, :traversal_b

    def traversals_for(a,b)
      TraversalCalculator.new.traversals_for(a,b)
    end

    def traversal_klasses
      result = []
      path = traversal_path

      path.each_cons(2) do |start, finish|
        klasses = traversals_for(start, finish)
        result.push(klasses.map{|k| k.new(start, finish)})
      end

      result.flatten
    end

    def sibling_directories(path)
      siblings(path).select{|f| File.directory?(f)}
    end

    def in_start_directory?(path)
      return false if path.directory?
      path_a.dirname == path
    end

    def in_finish_directory?(path)
      return false if path.directory?

      path_b.dirname == path
    end

    def distance(a, b, list)
      start_index = list.index{|f| a == f }
      finish_index = list.index{|f| b == f }
      (finish_index - start_index).abs
    end

    def traversal_path
      result = [path_a]
      if path_a.dirname == path_b.dirname
        return [path_a, path_b]
      end

      traversal = calculate_traversal_path
      current_path = path_a

      traversal.descend{|p|
        current_path = full(path_a, p)
        result.push(current_path)
      }

      remove_traversals_from_files_to_parents_then_back_down_to_sub_directories result
    end

    def remove_traversals_from_files_to_parents_then_back_down_to_sub_directories input
      in_parent = false
      last = input.first
      result = []

      input.each do |i|
        if in_parent
          in_parent = false

          if result[-2].dirname == i.dirname
            result.pop
            last = i
            result.push i
          end
        else
          in_parent =  ((last + "..")  == i)
          result.push i
          last = i
        end
      end

      result
    end

    def full(start, traversal)
      start.realpath + Pathname.new(traversal)
    end

    def calculate_traversal_path
      path_b.relative_path_from(path_a)
    end

    def top_ancestor
      common_directory_path(path_a, path_b)
    end

    def common_directory_path(path_a, path_b)
      separator = '/'
      dirs = [path_a.to_s, path_b.to_s]

      dir1, dir2 = dirs.minmax.map{|dir| dir.split(separator) }

      path = dir1.
        zip(dir2).
        take_while{|dn1,dn2| dn1 == dn2 }.
        map(&:first).
        join(separator)

      Pathname.new(path)
    end
  end

end
