require "active_model"

module SwifterEnum
  class SwifterEnumValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, a_value)
      return if options[:allow_nil] && a_value.nil?

      if !a_value.is_a?(SwifterEnum::Base) || a_value.class == SwifterEnum::Base
        record.errors.add(attribute, "#{a_value.value} is not a valid subclass of SwifterEnum")
      end

      unless a_value.class.values.keys.include?(a_value.value)
        record.errors.add(attribute, "#{a_value.value} is not a valid #{attribute} type")
      end
    end
  end
end
