# frozen_string_literal: true

# SwifterEnum - Swift-style enums for Ruby on Rails
#
# SwifterEnum transforms Rails enums from simple values into powerful objects
# with methods, computed properties, and type safety. Inspired by Swift's enums,
# this gem allows you to encapsulate behavior within your enum types.
#
# @see https://github.com/ConfusedVorlon/SwifterEnum
# @see SwifterEnum::Base
#
# @example Basic usage
#   # Define your enum
#   class StatusEnum < SwifterEnum::Base
#     set_values active: 0, inactive: 1
#
#     def label
#       case value
#       when :active then "Active"
#       when :inactive then "Inactive"
#       end
#     end
#   end
#
#   # Use in your model
#   class User < ApplicationRecord
#     swifter_enum :status, StatusEnum
#   end
#
#   # Access enum methods
#   user.status.label # => "Active"
#
require "swifter_enum/base"
require "swifter_enum/swifter_enum"
require "swifter_enum/swifter_enum_validator"
require "swifter_enum/railtie" if defined?(Rails)

if defined?(Rails::Generators) && Rails.env.development?
  require "swifter_enum/generators/enum/enum_generator"
end
