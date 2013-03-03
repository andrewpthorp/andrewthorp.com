require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = %w(models test)
  t.test_files = Dir.glob("**/*/*_test.rb")
  t.verbose = true
end

task :default => :test
