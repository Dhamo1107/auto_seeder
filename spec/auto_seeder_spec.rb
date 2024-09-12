# frozen_string_literal: true

require 'spec_helper'
require 'auto_seeder'

RSpec.describe AutoSeeder do
  it 'has a version number' do
    expect(AutoSeeder::VERSION).not_to be nil
  end
  before(:all) do
    ActiveRecord::Schema.define do
      create_table :test_models do |t|
        t.string :name
        t.integer :age
        t.text :description
        t.boolean :active
        t.timestamps
      end

      create_table :categories do |t|
        t.string :name
        t.timestamps
      end

      create_table :items do |t|
        t.string :name
        t.references :category, foreign_key: true
        t.timestamps
      end
    end

    class TestModel < ActiveRecord::Base; end

    class Category < ActiveRecord::Base
      has_many :items
    end

    class Item < ActiveRecord::Base
      belongs_to :category
    end
  end

  after(:all) do
    ActiveRecord::Schema.define do
      drop_table :items
      drop_table :categories
      drop_table :test_models
    end
  end

  describe '.seed' do
    it 'creates the specified number of records for the model' do
      expect { AutoSeeder.seed('TestModel', 3) }.to change { TestModel.count }.by(3)
    end

    it 'generates records with valid attributes' do
      AutoSeeder.seed('TestModel', 1)
      record = TestModel.last

      expect(record).to be_present
      expect(record.name).to be_a(String)
      expect(record.age).to be_a(Integer)
      expect(record.description).to be_a(String)
      expect(record.active).to be_in([true, false])
    end

    it 'handles associations correctly' do
      category = Category.create!(name: Faker::Name.name)
      expect { AutoSeeder.seed('Item', 3) }.to change { Item.count }.by(3)

      expect(Item.where(category_id: category.id).count).to eq(3)
    end

    it 'skips specified columns' do
      AutoSeeder.seed('TestModel', 1)
      record = TestModel.last

      expect(record.created_at).not_to be_nil
      expect(record.updated_at).not_to be_nil
    end

    it 'handles invalid record creation gracefully' do
      allow_any_instance_of(TestModel).to receive(:save).and_return(false)
      expect { AutoSeeder.seed('TestModel', 1) }.to output(/Failed to create TestModel/).to_stdout
    end

    it 'skips specified columns' do
      AutoSeeder.seed('TestModel', 1)
      record = TestModel.last

      expect(record.created_at).not_to be_nil
      expect(record.updated_at).not_to be_nil
    end
  end
end
