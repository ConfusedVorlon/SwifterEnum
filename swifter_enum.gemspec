# frozen_string_literal: true

require_relative "lib/swifter_enum/version"

Gem::Specification.new do |spec|
  spec.name = "swifter_enum"
  spec.version = SwifterEnum::VERSION
  spec.authors = ["Rob Jonson"]
  spec.email = ["rob@hobbyistsoftware.com"]

  spec.summary = "Active Record enum that uses a class, so you can add methods."
  spec.description = "Simple enum for active record that takes inspiration from Swift's enums to allow you to encapsulate enum logic within an enum class. This is easy to drop-in as a replacement for regular rails enums, with minimal changes required. Once you switch, then you can easily extend your enums with methods."
  spec.homepage = "https://github.com/ConfusedVorlon/SwifterEnum"
  spec.license = "MIT"

  #I'm using 3.2 and above. If you're willing/able to test on lower rubies, then please let me know and feel free to change this.
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ConfusedVorlon/SwifterEnum"
  spec.metadata["changelog_uri"] = "https://github.com/ConfusedVorlon/SwifterEnum"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 7.0"
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "activemodel", "~> 7.0"


  # Specify development dependencies
  spec.add_development_dependency "sqlite3", "~> 1.4" # For using SQL
  spec.add_development_dependency "minitest", "~> 5.22"
  spec.add_development_dependency "debug"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
