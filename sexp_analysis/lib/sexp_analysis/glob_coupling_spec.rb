require_relative "glob_coupling"

describe SexpAnalysis::GlobCoupling do
  it do
    glob = double "glob", files: %w(./fixtures/efferent_coupling.rb ./fixtures/example.rb ./fixtures/instance_coupling.rb)
    glob = described_class.new(glob)

    expect(glob.files).to eq(
      %w(./fixtures/efferent_coupling.rb ./fixtures/example.rb ./fixtures/instance_coupling.rb)
    )
  end
end


