# frozen_string_literal: true

require_relative 'lib/auto_seeder/version'

Gem::Specification.new do |spec|
  spec.name = 'auto_seeder'
  spec.version = AutoSeeder::VERSION
  spec.authors = ['Dhamo1107']
  spec.email = ['dhamodharansathish4533@gmail.com']

  spec.summary       = 'A gem to create fake data for models in your Rails application.'
  spec.description   = "The auto_seeder gem generates random, valid data for Rails models using Faker.
                        It can seed data for multiple models, handle associations and respect validations."

  spec.homepage      = 'https://github.com/dhamo1107/auto_seeder'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/dhamo1107/auto_seeder'
  spec.metadata['changelog_uri'] = 'https://github.com/dhamo1107/auto_seeder/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Dependencies
  spec.add_dependency 'faker'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_dependency 'thor', '~> 1.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
