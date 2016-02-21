module SexpAnalysis
  module Coupling
    class Instance
      def instances(sexp)
        sendable_from(sexp).each_with_object({}) do |s,o|
          iv_name = s.children[0].children[0]
          message_name = s.children[1]
          o[iv_name] ||= {}
          o[iv_name][message_name] ||= 0
          o[iv_name][message_name] += 1
        end

      end

      def sendable_from(sexp)
        if message_sendable?(sexp)
          return sexp
        end

        return unless sexp.respond_to?(:children)

        sexp.children.map{|c| sendable_from(c) }.reject(&:blank?).compact.flatten
      end

      def message_sendable?(sexp)
        sexp.respond_to?(:type) && sexp.type == :send
      end

      def sendable_name(sexp)
        return unless message_sendable?(sexp)

        sexp.children[0].children[0]
      end
    end
  end
end
