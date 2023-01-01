lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "direction/version"

Gem::Specification.new do |spec|
  spec.name = "direction"
  spec.version = Direction::VERSION
  spec.authors = ["'Jim Gay'"]
  spec.email = ["jim@saturnflyer.com"]
  spec.summary = "Forward messages to collaborators in East-oriented style."
  spec.description = "Forward messages to collaborators in East-oriented style."
  spec.homepage = "https://github.com/saturnflyer/direction"
  spec.license = "MIT"

  spec.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "CODE_OF_CONDUCT.md",
    "CHANGELOG.md",
    "Rakefile",
    "direction.gemspec",
    "lib/direction.rb",
    "lib/direction/version.rb"
  ]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.7"
end
