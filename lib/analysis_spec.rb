require "sexp"
require_relative "./analysis"

describe SexpSummary do
  it do
    summary = described_class.new("./fixtures/**/*.rb")

    expect(summary.sorted).to match_array [
      ["Exampl", 1],
      ["Some", 3],
      ["Arg", 2],

      ["Another", 1]
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
    glob_sexp = described_class.new("./fixtures/**/*.rb")

    expect(glob_sexp.contents.to_a).to eq(
      [["Exampl", "Some", "Some", "Arg", "Some", "Another", "Arg"]]
    )
  end
end



