# frozen_string_literal: true

# lib/auto_seeder/cli.rb
require 'thor'
require 'auto_seeder'

# The AutoSeeder::CLI class provides a command-line interface for seeding
# database records using Thor.
module AutoSeeder
  # It defines a command to seed a specified number of records for a given model.
  class CLI < Thor
    desc 'seed MODEL_NAME COUNT', 'Seed COUNT records for MODEL_NAME'
    def seed(model_name, count)
      AutoSeeder.seed(model_name, count.to_i)
    end
  end
end
