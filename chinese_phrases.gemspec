
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chinese_phrases/version"

Gem::Specification.new do |spec|
  spec.name          = "chinese_phrases"
  spec.version       = ChinesePhrases::VERSION
  spec.authors       = ["Ben D'Angelo"]
  spec.email         = ["ben@bendangelo.me"]

  spec.summary       = %q{Converts a csv of Chinese words to a csv of example sentences for use in Anki}
  spec.homepage      = "https://github.com/bendangelo/chinese_phrases"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["chinese_phrases"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', "~> 0.17"
  spec.add_dependency 'tradsim', "~> 0.5"
  spec.add_dependency 'thor', "~> 0.20"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
