# frozen_string_literal: true

require_relative 'lib/bag/version'

Gem::Specification.new do |spec|
  spec.name = 'bag.rb'
  spec.version = Bag::VERSION
  spec.authors = ['Shannon Skipper']
  spec.email = ['shannonskipper@gmail.com']

  spec.summary = 'A bag (multiset) data structure'
  spec.description = 'A pure Ruby implementation of a bag (multiset) collection that tracks element occurrences'
  spec.homepage = 'https://github.com/havenwood/bag.rb'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = %w[LICENSE.txt Rakefile README.md] + Dir['lib/**/*.rb']
end
