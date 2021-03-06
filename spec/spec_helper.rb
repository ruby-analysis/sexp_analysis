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


def match_file_array(a,b)
  format = lambda{|f| f.to_s.gsub(Regexp.escape(fixture_path.to_s), "")}

  a = a.map &format
  b = b.map &format

  expect(a).to match_array(b.map{|f| t(f)}.map(&format))
end


