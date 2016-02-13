require "./analysis"

describe SexpSummary do
  it do
    summary = described_class.new("./fixtures/**/*.rb")

    expect(summary.sorted).to match_array [
      ["Exampl", 1],
      ["Some", 2],
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

    expect(glob_sexp.contents.to_a).to eq([
      ["Exampl", "Some", "Some", "Another"]
    ])
  end
end

describe SexpStemmer do
  it do
    stemmer = described_class.new("./fixtures/example.rb")

    expect(stemmer.stemmed_strings.to_a).to eq(
      ["Exampl", "Some", "Some", "Another"]
    )
  end
end


describe FileSexp do
  it do
    file_sexp = described_class.new("./fixtures/example.rb")


    expect(file_sexp.sexp).to eq(
      [:Example, :some_method, :@some_instance_variable, :another_method]
    )
  end
end
