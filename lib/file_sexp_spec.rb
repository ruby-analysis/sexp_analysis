require_relative "file_sexp"

describe FileSexp do
  describe "#flattened_sexp" do
    it do
      file_sexp = described_class.new("./fixtures/example.rb")

      expect(file_sexp.flattened_sexp).to eq(
        [:Example, nil, :some_method, :_some_arg, :@some_instance_variable, 1, :another_method, :_args_name, 2]
      )
    end
  end

  def s(sym, *args)
    Parser::AST::Node.new(sym, args)
  end

  describe "#sexp" do
    it do
      file_sexp = described_class.new("./fixtures/example.rb")

      expected = s(:class, s(:const, nil, :Example),
         nil,
         s(:begin,
           s(:def, :some_method,
             s(:args, s(:arg, :_some_arg)),
             s(:ivasgn, :@some_instance_variable, s(:int, 1))),
           s(:def, :another_method, s(:args, s(:restarg, :_args_name)), s(:int, 2))))

      expect(file_sexp.sexp.to_a).to eq(expected.to_a)
    end
  end

  describe "#sexp_names" do
    it do
      file_sexp = described_class.new("./fixtures/example.rb")

      expected = [[:Example],
                  nil,
                  [[:some_method, [[:_some_arg]], [:@some_instance_variable, [1]]],
                   [:another_method, [[:_args_name]], [2]]]]
      expect(file_sexp.sexp_names).to eq expected

    end
  end
end
