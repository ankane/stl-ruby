require "bundler/gem_tasks"
require "rake/testtask"
require "rake/extensiontask"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task default: :test

Rake::ExtensionTask.new("stl") do |ext|
  ext.name = "ext"
  ext.lib_dir = "lib/stl"
end

task :remove_ext do
  path = "lib/stl/ext.bundle"
  File.unlink(path) if File.exist?(path)
end

Rake::Task["build"].enhance [:remove_ext]
