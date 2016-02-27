require_relative "glob"

describe SexpAnalysis::Glob do
  it do
    glob = described_class.new("./fixtures/ruby/*.rb")

    expect(glob.files).to eq(
      %w(./fixtures/ruby/efferent_coupling.rb ./fixtures/ruby/example.rb ./fixtures/ruby/instance_coupling.rb)
    )
  end
end


