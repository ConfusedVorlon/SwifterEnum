# frozen_string_literal: true

require "swifter_enum/base"
require "swifter_enum/swifter_enum"
require "swifter_enum/swifter_enum_validator"
require "swifter_enum/railtie" if defined?(Rails)

if defined?(Rails::Generators) && Rails.env.development?
  require "swifter_enum/generators/enum/enum_generator"
end
