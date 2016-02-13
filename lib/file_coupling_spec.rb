require "byebug"
require_relative "file_coupling"

describe FileCoupling do
  it do
    result = subject.klasses "fixtures/efferent_coupling.rb"

    expect(result).to eq [:EfferentCoupling, :This, :That, :SomeOther, :SoMuchCoupling, :HereIsSomeMore]
  end

    #s(:class,
    #  s(:const, nil, :EfferentCoupling),
    #  nil,
    #  s(:def, :lots_of_coupling,                 #children[2]
    #    s(:args),
    #    s(:begin,
    #      s(:send,
    #        s(:const, nil, :This),              sexp.children[2].children[2].children[0].children[0]
    #        :send_message),
    #      s(:send,
    #        s(:const, nil, :That), :send_message),
    #      s(:send,
    #        s(:const, nil, :SomeOther), :send_message),
    #      s(:send,
    #        s(:const, nil, :SoMuchCoupling), :found_in_here),
    #      s(:send,
    #        s(:const, nil, :HereIsSomeMore), :for_good_measure))))
    #
    let(:sexp) { FileSexp.for("fixtures/efferent_coupling.rb") }
    let(:constant_node) { sexp.children[2].children[2].children[0].children[0] }

  describe "const?" do
    it do
      expect(subject.const?(sexp)).to eq false
    end

    it do
      expect(subject.const?(constant_node)).to eq true
    end
  end

  describe "constant_name" do
    it do
      expect(subject.constant_name(constant_node)).to eq :This
    end
  end
end

