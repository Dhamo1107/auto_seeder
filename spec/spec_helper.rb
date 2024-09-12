# frozen_string_literal: true

require 'active_record'
require 'sqlite3'  # In-memory SQLite for tests
require 'auto_seeder'

# Configure ActiveRecord to use an in-memory SQLite3 database
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
