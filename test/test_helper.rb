require "minitest/autorun"
require_relative "../lib/swifter_enum"
require "active_record"
require 'debug' #should be available in testing

# Setup localisation
require "i18n"
I18n.load_path += Dir[File.expand_path("./config/locales/*.yml", __dir__)]
I18n.default_locale = :en

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

require_relative "models/emotion_enum" # Note in rails app - enum can be loaded automatically from models/swifter_enum/status_enum.rb
require_relative "models/size_enum"
require_relative "models/test_model"

ActiveRecord::Schema.define do
  create_table :test_models, force: true do |t|
    t.integer :emotion
    t.integer :size
  end
end
