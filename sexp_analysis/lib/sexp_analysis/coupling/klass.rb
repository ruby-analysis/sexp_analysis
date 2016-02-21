require 'active_support/core_ext/string'

module Coupling
  class Klass
    def klasses(sexp)
      if const?(sexp)
        return constant_name(sexp)
      else
        return unless sexp.respond_to?(:children)
        return sexp.children.map{|c| klasses(c) }.compact.flatten
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
end
