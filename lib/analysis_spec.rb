require "sexp"
require_relative "./analysis"

describe AnalysisSummary do
  let(:summary) { described_class.new("./fixtures/**/example.rb") }


  describe "#sorted" do
    before do
      expect(summary).to receive(:sexp_contents).and_return %w(a a b c) 
    end

    it do
      expect(summary.sorted).to match_array [
        ["a", 2],
        ["b", 1],
        ["c", 1]
      ]
    end
  end

  it do
    summary = described_class.new(["./fixtures/example.rb"])

    expect(summary.sexp_contents.to_a).to eq(
      [["Exampl", "Some", "Some", "Arg", "Some", "Another", "Arg"]]
    )
  end
end

describe Counter do
  it do
    subject.add *%w(egg cheese egg banana)

    expect(subject.to_h).to eq({"egg" => 2, "cheese" => 1, "banana" => 1})
  end
end



