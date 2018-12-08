
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dependency_bundle/version"

Gem::Specification.new do |spec|
  spec.name          = "dependency_bundle"
  spec.version       = DependencyBundle::VERSION
  spec.authors       = ["Chris Hoffman"]
  spec.email         = ["yarmiganosca@gmail.com"]

  spec.summary       = %q{An Injectable Dependency Container implementation for Ruby}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/yarmiganosca/dependency_bundle"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "structured_changelog"
  spec.add_development_dependency "pry-byebug"
end
