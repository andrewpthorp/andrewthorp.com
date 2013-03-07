require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = %w(models test)
  t.test_files = Dir.glob("**/*/*_test.rb")
  t.verbose = true
end

task :default => :test

desc "Copy emoji to the Rails `public/images/emoji` directory"
task :emoji do
  require 'emoji'

  target = "#{Rake.original_dir}/public/images/emoji"

  mkdir_p "#{target}"
  Dir["#{Emoji.images_path}/emoji/*.png"].each do |src|
    cp src, "#{target}/"
  end

  mkdir_p "#{target}/unicode"
  Dir["#{Emoji.images_path}/emoji/unicode/*.png"].each do |src|
    cp src, "#{target}/unicode/"
  end
end
