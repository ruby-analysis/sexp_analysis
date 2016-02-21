require_relative 'sexp_stemmer'

describe SexpStemmer do
  it do
    stemmer = described_class.new("./fixtures/example.rb")

    expect(stemmer.stemmed_strings.to_a).to eq(
      ["Exampl", "Some", "Some", "Arg", "Some", "Another", "Arg"]
    )
  end
end



