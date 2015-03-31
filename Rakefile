require 'rspec/core/rake_task'
require "bundler/gem_tasks"

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec)

task :set_private_key_permissions do
  File.chmod(0400, "./spec/assets/gh_key.private")
end

task :spec => :set_private_key_permissions
task :default => :spec
