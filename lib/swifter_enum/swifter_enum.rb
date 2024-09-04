require "active_support/concern"

# Adds methods to Rails Models
# swifter_enum
# model.enum_attribute (getter/setter)
# model.enum_attribute_raw (getter/setter to underlying enum)
# model.enum_attribute_raws

module SwifterEnum
  extend ActiveSupport::Concern

  class_methods do
    def swifter_enum(enum_name, enum_klass, enum_options = {})
      # Define the enum using values from the enum class
      enum(enum_name, enum_klass.values, **enum_options)

      # Define getter method
      define_method(enum_name) do
        attribute = read_attribute(enum_name)
        enum_klass.new(attribute) if attribute.present?
      end

      # Define setter method
      define_method(:"#{enum_name}=") do |new_value|
        if new_value.is_a?(enum_klass)
          super(new_value.value)
        else
          super(new_value)
        end
      end

      # Raw setter/getter allow escape valve for e.g. administrate
      # So, if your swifter_enum is
      # swifter_enum :camera, CameraKind
      # you can get and set camera_raw with standard enum values
      # and you can get the mapping with YourClass.camera_raws
      # This allows you to use andminstrate as an example on camera_raw and expect form selects to work normally.

      # Define raw getter method
      define_method(:"#{enum_name}_raw") do
        read_attribute(enum_name)
      end

      # Define raw setter method
      define_method(:"#{enum_name}_raw=") do |new_value|
        write_attribute(enum_name, new_value)
      end

      # Define class method to fetch the keys
      # Rails returns string keys, so copy that
      define_singleton_method(:"#{enum_name}_raws") do
        enum_klass.values.transform_keys(&:to_s)
      end
    end
  end
end
