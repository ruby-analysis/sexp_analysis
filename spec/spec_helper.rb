require "byebug"

def expand_fixture_path(path="")
  s = File.join File.expand_path(fixture_path), path

  Pathname.new(s).realpath
end

def fixture_path
  Pathname.new("./fixtures/tree").realpath
end

def t(path)
  Pathname.new(File.join(fixture_path, path)).realpath
end



