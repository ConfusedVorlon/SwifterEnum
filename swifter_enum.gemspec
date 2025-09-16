# frozen_string_literal: true

require_relative "lib/swifter_enum/version"

Gem::Specification.new do |spec|
  spec.name = "swifter_enum"
  spec.version = SwifterEnum::VERSION
  spec.authors = ["Rob Jonson"]
  spec.email = ["rob@hobbyistsoftware.com"]

  spec.summary = "Swift-style enums for Rails that encapsulate behavior within your enum types"
  spec.description = "SwifterEnum transforms Rails enums from simple values into powerful objects with methods, computed properties, and type safety. Your enums become smart: payment_status.can_refund?, subscription.price, status.icon - all while maintaining 100% Rails enum compatibility. Drop-in replacement that eliminates scattered helper methods and case statements throughout your codebase."
  spec.homepage = "https://github.com/ConfusedVorlon/SwifterEnum"
  spec.license = "MIT"

  # I'm using 3.2 and above. If you're willing/able to test on lower rubies, then please let me know and feel free to change this.
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

  spec.add_dependency "activerecord", ">= 7.0", "< 9.0"
  spec.add_dependency "activesupport", ">= 7.0", "< 9.0"
  spec.add_dependency "activemodel", ">= 7.0", "< 9.0"

  # Specify development dependencies
  spec.add_development_dependency "sqlite3", ">= 1.4"
  spec.add_development_dependency "minitest", "~> 5.22"
  spec.add_development_dependency "debug"
  spec.add_development_dependency "appraisal", "~> 2.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
