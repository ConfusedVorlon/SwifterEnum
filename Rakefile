# frozen_string_literal: true

require 'rake/testtask'
require "bundler/gem_tasks"
require "standard/rake"

# run rake standard:fix to standardise

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: [:standard, :test]
