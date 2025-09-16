require "active_support/concern"

# ActiveRecord integration for SwifterEnum
#
# This module is automatically included in ActiveRecord::Base to provide
# the swifter_enum class method for defining Swift-style enums on models.
#
# @example Basic usage
#   class Order < ApplicationRecord
#     swifter_enum :status, OrderStatusEnum
#     swifter_enum :priority, PriorityEnum, prefix: true
#   end
#
#   order.status              # => #<OrderStatusEnum @value=:pending>
#   order.status.completed?   # => false (custom method)
#   order.status = :completed # Standard setter
#   order.completed!          # Bang method (sets and saves)
#   order.completed?          # Query method
#
module SwifterEnum
  extend ActiveSupport::Concern

  class_methods do
    # Defines a SwifterEnum attribute on an ActiveRecord model
    #
    # This creates a full-featured enum that returns enum class instances
    # instead of simple values, while maintaining Rails enum compatibility.
    #
    # @param enum_name [Symbol] the name of the enum attribute
    # @param enum_klass [Class] the SwifterEnum::Base subclass to use
    # @param enum_options [Hash] options passed to Rails enum method (e.g., prefix: true)
    #
    # @example Basic definition
    #   swifter_enum :status, StatusEnum
    #
    # @example With prefix option
    #   swifter_enum :payment_status, PaymentStatusEnum, prefix: true
    #
    #   # Without prefix: order.pending! and order.pending?
    #   # With prefix: order.payment_status_pending! and order.payment_status_pending?
    #   order.payment_status_pending!    # Sets to pending and saves
    #   order.payment_status_completed?  # => false
    #   Order.payment_status_completed   # Scope for completed orders
    #
    # @note This method creates the following:
    #   - Getter that returns enum instance: `model.status`
    #   - Setter that accepts symbol/string/instance: `model.status = :active`
    #   - Raw getter for compatibility: `model.status_raw`
    #   - Raw setter for compatibility: `model.status_raw = "active"`
    #   - Class method for values: `Model.status_raws`
    #   - All standard Rails enum methods (scopes, bang methods, query methods)
    #
    def swifter_enum(enum_name, enum_klass, enum_options = {})
      # Define the enum using values from the enum class
      enum(enum_name, enum_klass.values, **enum_options)

      # Define getter method that returns enum instance
      # @return [SwifterEnum::Base, nil] enum instance or nil if not set
      define_method(enum_name) do
        attribute = read_attribute(enum_name)
        enum_klass.new(attribute) if attribute.present?
      end

      # Define setter method that accepts multiple input types
      # @param new_value [Symbol, String, SwifterEnum::Base] the value to set
      define_method(:"#{enum_name}=") do |new_value|
        if new_value.is_a?(enum_klass)
          super(new_value.value)
        else
          super(new_value)
        end
      end

      # Raw getter provides access to underlying Rails enum value
      # Useful for form builders and admin interfaces like Administrate
      # @return [String, nil] the raw enum value as stored in the database
      define_method(:"#{enum_name}_raw") do
        read_attribute(enum_name)
      end

      # Raw setter allows setting enum using raw values
      # @param new_value [String, Symbol, Integer] the raw value to set
      define_method(:"#{enum_name}_raw=") do |new_value|
        write_attribute(enum_name, new_value)
      end

      # Class method to get enum value mappings
      # Returns string keys to match Rails convention
      # @return [Hash<String, Integer>] hash of string keys to database values
      #
      # @example Using with Administrate
      #   class BookingDashboard < Administrate::BaseDashboard
      #     ATTRIBUTE_TYPES = {
      #       # Use the _raw attribute and _raws collection for Administrate
      #       album_status_raw: Field::Select.with_options(
      #         collection: Booking.album_status_raws.keys
      #       ),
      #       # Other fields...
      #     }
      #   end
      define_singleton_method(:"#{enum_name}_raws") do
        enum_klass.values.transform_keys(&:to_s)
      end
    end
  end
end
