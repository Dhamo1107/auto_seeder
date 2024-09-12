# frozen_string_literal: true

require_relative "auto_seeder/version"
require 'active_record'
require 'faker'

module AutoSeeder
  def self.seed(model_name, count)
    model = model_name.classify.constantize
    count.times do
      attributes = generate_attributes_for_model(model)

      # Create the record if valid
      record = model.new(attributes)
      if record.save
        puts "Created #{model_name} with ID: #{record.id}"
      else
        puts "Failed to create #{model_name}: #{record.errors.full_messages.join(', ')}"
      end
    end
  end

  def self.generate_attributes_for_model(model)
    attributes = {}

    # Loop through each column of the model
    model.columns.each do |column|
      next if %w[id created_at updated_at].include?(column.name)

      # Generate data based on column type
      attributes[column.name] = case column.type
                                when :string
                                  Faker::Lorem.sentence
                                when :text
                                  Faker::Lorem.paragraph
                                when :integer
                                  handle_integer_column(model, column)
                                when :datetime
                                  Faker::Time.between(from: 1.year.ago, to: Time.current)
                                when :boolean
                                  [true, false].sample
                                else
                                  nil
                                end
    end

    # Handle model associations
    handle_associations(model, attributes)

    attributes
  end

  def self.handle_integer_column(model, column)
    if column.name.end_with?("_id") # Foreign key
      associated_model = column.name.gsub("_id", "").classify.constantize
      associated_model.pluck(:id).sample || associated_model.create!(name: Faker::Name.name).id
    else
      rand(1..100)
    end
  end

  def self.handle_associations(model, attributes)
    model.reflect_on_all_associations.each do |association|
      case association.macro
      when :belongs_to
        associated_record = association.klass.order("RANDOM()").first || association.klass.create!(name: Faker::Name.name)
        attributes[association.foreign_key] = associated_record.id
      when :has_one
        attributes[association.name] = association.klass.create!(name: Faker::Name.name)
      when :has_many
        2.times { association.klass.create!(name: Faker::Name.name, model_name.foreign_key => model.id) }
      end
    end
  end
end

