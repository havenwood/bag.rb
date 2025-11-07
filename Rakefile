# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'
require 'rubocop/rake_task'

task default: %i[test rubocop]

Minitest::TestTask.create

RuboCop::RakeTask.new do |task|
  task.plugins << 'rubocop-minitest'
end
