# frozen_string_literal: true

require_relative "lib/usos_auth/version"

Gem::Specification.new do |spec|
  spec.name = "usos_auth"
  spec.version = UsosAuth::VERSION
  spec.authors = ["mikolajczu"]
  spec.email = ["mikeyczu@gmail.com"]

  spec.summary = "Gem for authenticating users via the USOS API"
  spec.description = "A Ruby gem to simplify USOS API authentication."
  spec.homepage = "https://github.com/mikolajczu/usos_auth"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "oauth", "~> 0.5.1"
  gem 'faraday', '~> 2.3'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
