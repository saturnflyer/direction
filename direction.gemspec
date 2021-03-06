# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'direction/version'

Gem::Specification.new do |spec|
  spec.name          = "direction"
  spec.version       = Direction::VERSION
  spec.authors       = ["'Jim Gay'"]
  spec.email         = ["jim@saturnflyer.com"]
  spec.summary       = %q{Forward messages to collaborators in East-oriented style.}
  spec.description   = %q{Forward messages to collaborators in East-oriented style.}
  spec.homepage      = "https://github.com/saturnflyer/direction"
  spec.license       = "MIT"

  spec.files         = [".gitignore", ".travis.yml", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "direction.gemspec", "lib/direction.rb", "lib/direction/version.rb", "sample.rb", "sample/accountant.rb", "sample/customer.rb", "sample/kitchen.rb", "sample/micro_manager.rb", "sample/server.rb", "test/direction_test.rb", "test/test_helper.rb"]
  spec.test_files    = ["test/direction_test.rb", "test/test_helper.rb"]
  spec.require_paths = ["lib"]
end
