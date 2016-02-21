require_relative "glob"

describe SexpAnalysis::Glob do
  it do
    glob = described_class.new("./fixtures/**/*.rb")

    expect(glob.files).to eq(
      %w(./fixtures/efferent_coupling.rb ./fixtures/example.rb ./fixtures/instance_coupling.rb)
    )
  end
end


