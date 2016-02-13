require 'parser/current'

class FileSexp < Struct.new(:filename)
  def flattened_sexp
    sexp_names.flatten
  end

  def sexp
    parse(raw)
  end

  def sexp_names
    to_a sexp
  end


  private

  def raw
    return unless filename[/\.rb$/]

    File.read(filename) unless File.directory?(filename)
  end

  def parser
    @parser ||= Parser::CurrentRuby
  end

  def parse(c)
    return [] if c.blank?
    parser.parse(c)
  end

  def to_a(sexp)
    sexp.to_a.map{|s| s.respond_to?(:to_a) ? to_a(s) : s }
  end
end



