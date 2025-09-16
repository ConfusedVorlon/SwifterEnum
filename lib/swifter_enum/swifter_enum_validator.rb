require "active_model"

module SwifterEnum
  # Custom validator for SwifterEnum attributes
  #
  # Validates that an attribute contains a valid SwifterEnum instance
  # with a value that exists in the enum's defined values.
  #
  # @example Basic usage
  #   class Order < ApplicationRecord
  #     swifter_enum :status, OrderStatusEnum
  #     validates :status, swifter_enum: true
  #   end
  #
  # @example Allow nil values
  #   class Order < ApplicationRecord
  #     swifter_enum :status, OrderStatusEnum
  #     validates :status, swifter_enum: { allow_nil: true }
  #   end
  #
  class SwifterEnumValidator < ActiveModel::EachValidator
    # Validates a single attribute value
    #
    # @param record [ActiveRecord::Base] the model instance being validated
    # @param attribute [Symbol] the attribute name being validated
    # @param a_value [Object] the current value of the attribute
    #
    # @note Validation checks:
    #   1. Rejects nil unless allow_nil option is true
    #   2. Ensures value is a SwifterEnum::Base subclass instance (not Base itself)
    #   3. Verifies the enum value exists in the class's defined values
    #
    def validate_each(record, attribute, a_value)
      if a_value.nil?
        return if options[:allow_nil]

        record.errors.add(attribute, "nil value for #{attribute} is not allowed")
        return
      end

      if !a_value.is_a?(SwifterEnum::Base) || a_value.instance_of?(SwifterEnum::Base)
        record.errors.add(attribute, "#{a_value.value} is not a valid subclass of SwifterEnum")
      end

      unless a_value.class.values.key?(a_value.value)
        record.errors.add(attribute, "#{a_value.value} is not a valid #{attribute} type")
      end
    end
  end
end
