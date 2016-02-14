require "sexp"
require_relative "./analysis"

describe SexpSummary do
  let(:glob_sexp) { double "glob_sexp", contents: %w(a a b c) }

  before do
    expect(GlobSexp).to receive(:new).and_return glob_sexp
  end

  it do
    summary = described_class.new("./fixtures/**/example.rb")

    expect(summary.sorted).to match_array [
      ["a", 2],
      ["b", 1],
      ["c", 1]
    ]
  end
end

describe WordCount do
  it do
    subject.add *%w(egg cheese egg banana)

    expect(subject.to_h).to eq({"egg" => 2, "cheese" => 1, "banana" => 1})
  end
end

describe GlobSexp do
  it do
    glob_sexp = described_class.new("./fixtures/**/example.rb")

    expect(glob_sexp.contents.to_a).to eq(
      [["Exampl", "Some", "Some", "Arg", "Some", "Another", "Arg"]]
    )
  end
end



