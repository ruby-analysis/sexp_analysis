# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sexp_analysis/version'

Gem::Specification.new do |spec|
  spec.name          = "sexp_analysis"
  spec.version       = SexpAnalysis::VERSION
  spec.authors       = ["Mark Burns"]
  spec.email         = ["markthedeveloper@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.homepage      = "https://github.com/markburns/sexp_analysis"


  spec.add_development_dependency "growl"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency "activesupport"

  spec.add_dependency "stemmify" #Let's eliminate this dependency
  spec.add_dependency "colorize" #Let's eliminate this dependency
  spec.add_dependency "sexp_processor"
  spec.add_dependency "rubytree"
  spec.add_dependency "parser"


  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").
    reject { |f| f.match(%r{^(test|spec|features)/}) }.
    reject{|f| f.match(%r{_spec.rb$})}

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
