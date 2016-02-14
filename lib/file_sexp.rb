require 'parser/current'
require 'active_support/core_ext/string'


class FileSexp  < Struct.new(:filename)
  def self.for(filename)
    new(filename).sexp
  end

  def flattened_sexp
    sexp_names.flatten
  end

  def sexp
    parse(raw)
  end

  def sexp_names(filter=nil)
    to_a sexp, filter
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

  def to_a(sexp, filter=nil)
    return unless sexp

    sexp.children.map &children_of(filter)
  end

  def children_of(filter=nil)
    lambda do |s|
      if s.respond_to?(:children)
        children = to_a(s, filter).reject(&:blank?)

        if filter && s.type == filter
          {s.type => children}
        else
          children
        end
      else
        s
      end
    end
  end
end
