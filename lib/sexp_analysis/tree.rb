require 'colorize'

class Writer < Struct.new(:search)
  def add_files(glob)
    Dir.glob(glob).each do |f|
      add_file f
    end
  end

  private

  def add_file(f)
    klass = display_klass(f)

    append klass.new(f)
  end

  def append(v)
    buffer << v.to_s
  end

  def to_s
    buffer
  end

  def display_klass(file)
    return Display::Directory if File.directory?(file)
    contents_present = File.read(file)[search]
    file_match = file[search]
    return Display::Cohesive if file_match && contents_present
    return Display::CodeSmell if contents_present

    Display::Dot
  end

  def buffer
    @buffer ||= ""
  end
end


module Display
  class Directory < Struct.new(:raw)
    def to_s
      "\n#{raw}"
    end
  end

  class Dot < Struct.new(:raw)
    def to_s
      "."
    end
  end

  class Cohesive < Struct.new(:raw)
    def to_s
      "√".green
    end
  end
  
  class CodeSmell < Struct.new(:raw)
    def to_s
      "X".red
    end
  end
end
