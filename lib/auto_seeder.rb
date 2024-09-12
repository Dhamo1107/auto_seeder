# frozen_string_literal: true

require_relative 'auto_seeder/version'
require 'active_record'
require 'faker'

# This module provides functionality to seed a specified model
# with a given number of records in a Rails application.
# It generates fake attributes for the model using Faker
# and creates the specified count of records in the database.
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
        puts "Failed to create #{model_name}: #{record.errors.full_messages.join(", ")}"
      end
    end
  end

  def self.generate_attributes_for_model(model)
    attributes = {}
    # Generate attributes for columns
    model.columns.each do |column|
      next if skip_column?(column.name)

      attributes[column.name] = generate_attribute_for_column(model, column)
    end
    # Handle model associations
    handle_associations(model, attributes)
    attributes
  end

  def self.handle_integer_column(_model, column)
    if column.name.end_with?('_id') # Foreign key
      associated_model = column.name.gsub('_id', '').classify.constantize
      associated_model.pluck(:id).sample || associated_model.create!(name: Faker::Name.name).id
    else
      rand(1..100)
    end
  end

  def self.handle_associations(model, attributes)
    model.reflect_on_all_associations.each do |association|
      case association.macro
      when :belongs_to
        handle_belongs_to_association(association, attributes)
      when :has_one
        handle_has_one_association(association, attributes)
      when :has_many
        handle_has_many_association(association, model)
      end
    end
  end

  def self.handle_belongs_to_association(association, attributes)
    associated_record = association.klass.order('RANDOM()').first || association.klass.create!(name: Faker::Name.name)
    attributes[association.foreign_key] = associated_record.id
  end

  def self.handle_has_one_association(association, attributes)
    attributes[association.name] = association.klass.create!(name: Faker::Name.name)
  end

  def self.handle_has_many_association(association, model)
    foreign_key = association.foreign_key
    model_id = model.id

    2.times do
      association.klass.create!(name: Faker::Name.name, "#{foreign_key}" => model_id)
    end
  end

  def self.skip_column?(column_name)
    %w[id created_at updated_at].include?(column_name)
  end

  def self.generate_attribute_for_column(model, column)
    case column.type
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
    end
  end
end
