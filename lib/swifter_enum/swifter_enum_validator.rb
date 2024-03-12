require "active_model"

module SwifterEnum
  class SwifterEnumValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, a_value)
      if !a_value.is_a?(SwifterEnum::Base) || a_value.instance_of?(SwifterEnum::Base)
        record.errors.add(attribute, "#{a_value.value} is not a valid subclass of SwifterEnum")
      end

      if a_value.value.nil?
        return if options[:allow_nil]

        record.errors.add(attribute, "nil value for #{attribute} is not allowed")
      end

      unless a_value.class.values.key?(a_value.value)
        # binding.b
        record.errors.add(attribute, "#{a_value.value} is not a valid #{attribute} type")
      end
    end
  end
end
