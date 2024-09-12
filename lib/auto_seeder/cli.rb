# lib/auto_seeder/cli.rb
require 'thor'
require 'auto_seeder'

module AutoSeeder
  class CLI < Thor
    desc "seed MODEL_NAME COUNT", "Seed COUNT records for MODEL_NAME"
    def seed(model_name, count)
      AutoSeeder.seed(model_name, count.to_i)
    end
  end
end
