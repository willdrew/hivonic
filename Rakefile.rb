require 'rake'
require 'rake/testtask'
require 'rake/clean'

Rake::TestTask.new do |task|
  task.libs << %w(test lib)
  task.pattern = 'test/unit/*_test.rb'
  task.ruby_opts << '-rtest_helper'
end

task :default => :test
