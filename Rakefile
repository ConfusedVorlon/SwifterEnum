# frozen_string_literal: true

require "rake/testtask"
require "bundler/gem_tasks"
require "standard/rake"

# run rake standard:fix to standardise

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end


# publish with rake release:publish
namespace :release do
  desc "Read version, build gem, tag and push release"
  task :publish do
    # Read version
    version_file_path = File.expand_path("../lib/swifter_enum/version.rb", __FILE__)
    version_file_content = File.read(version_file_path)
    version_match = version_file_content.match(/VERSION = "(\d+\.\d+\.\d+)"/)
    unless version_match
      puts "Version could not be found in #{version_file_path}"
      exit 1
    end
    version = version_match[1]
    gem_name = "swifter_enum-#{version}.gem"

    # Build gem
    Rake::Task["build"].invoke

    # Git tag
    system("git add .")
    system("git commit -m 'Release version #{version}'")
    system("git tag -a v#{version} -m 'Version #{version} release'")
    system("git push origin main --tags")

    # Push gem to RubyGems
    system("gem push pkg/#{gem_name}")
  end
end


task default: [:standard, :test]
