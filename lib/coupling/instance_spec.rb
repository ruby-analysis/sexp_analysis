require_relative "../file_sexp"
require_relative "instance"
require "byebug"

describe Coupling::Instance do
  #s(:class,
  #s(:const, nil, :EfferentCoupling), nil,
  #s(:begin,
  #  s(:def, :instance_coupling,
  #    s(:args,
  #      s(:arg, :some_instance)),
  #    s(:begin,
  #      s(:send,
  #        s(:lvar, :some_instance), :this_message),      #sexp.children[2].children[1].children[2].children[0]
  #      s(:send,
  #        s(:lvar, :some_instance), :that_message),
  #      s(:send,
  #        s(:lvar, :some_instance), :tons_more))),
  #  s(:def, :more_instance_coupling,
  #    s(:args,
  #      s(:arg, :some_instance)),
  #    s(:begin,
  #      s(:send,
  #        s(:lvar, :some_instance), :another_message),
  #      s(:send,
  #        s(:lvar, :some_instance), :yet_more),
  #      s(:send,
  #        s(:lvar, :some_instance), :here_we_go)))))
  #
  let(:sexp) { FileSexp.for("fixtures/instance_coupling.rb") }

  it do
    result = subject.instances(sexp)

    expect(result).to eq({
      some_instance: {
        this_message: 2,
        that_message: 1,
        tons_more: 1,
        another_message: 1,
        yet_more: 1,
        here_we_go: 1,
      },
      another: {
        message: 1,
        second_message: 1,
      }
    })
  end

  #s(:send,
  #  s(:lvar, :some_instance), :this_message)
  let(:sendable_node) {
    sexp.children[2].children[1].children[2].children[0]
  }

  describe "message_sendable?" do
    it do
      expect(subject.message_sendable?(sexp)).to eq false
    end

    it do
      expect(subject.message_sendable?(sendable_node)).to eq true
    end
  end

  describe "sendable_name" do
    it do
      expect(subject.sendable_name(sendable_node)).to eq :some_instance
    end
  end

  describe "sendable_from" do
    it do
      expect(subject.sendable_from(sendable_node)).to eq sendable_node
    end

    it do
      result = subject.sendable_from(sexp)
      expect(result.length).to eq 9
      all_nodes = result.all?{|r| r.kind_of?(Parser::AST::Node)}

      expect(all_nodes).to eq true
      message_names = result.map{|r| r.children.last }
      expect(message_names).to eq %w(
      this_message that_message tons_more
      this_message
      another_message
      yet_more
      here_we_go
      message
      second_message
      ).map &:to_sym

    end
  end

end

