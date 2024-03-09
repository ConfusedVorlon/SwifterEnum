require "minitest/autorun"
require_relative '../lib/swifter_enum'
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

require_relative "models/status_enum" #Note in rails app - enum can be loaded from models/swifter_enum/status_enum.rb
require_relative "models/test_model"


ActiveRecord::Schema.define do
  create_table :test_models, force: true do |t|
    t.string :name
    t.integer :status
    # Add other columns as needed for your tests
  end
end
