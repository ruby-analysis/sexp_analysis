require_relative "file_sexp"

class FileCoupling
  def klasses(filename)
    sexp = FileSexp.for(filename)

    constants_from(sexp)
  end

  def constants_from(sexp)
    if const?(sexp)
      return constant_name(sexp)
    else
      return unless sexp.respond_to?(:children)
      return sexp.children.map{|c| constants_from(c) }.compact.flatten
    end
  end

  def const?(sexp)
    return unless sexp.respond_to?(:type)

    sexp.type == :const
  end

  def constant_name(sexp)
    return unless const?(sexp)

    sexp.children[1]
  end
end
