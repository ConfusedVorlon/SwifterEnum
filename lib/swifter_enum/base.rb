module SwifterEnum
  # Base class for creating Swift-style enums in Rails
  #
  # SwifterEnum allows you to create enums that are objects with methods,
  # rather than simple values. This enables you to encapsulate behavior
  # within your enum types.
  #
  # @example Define a new enum
  #   class PaymentStatusEnum < SwifterEnum::Base
  #     set_values pending: 0, processing: 10, completed: 20
  #
  #     def completed?
  #       value == :completed
  #     end
  #   end
  #
  # @example Use in an ActiveRecord model
  #   class Order < ApplicationRecord
  #     swifter_enum :payment_status, PaymentStatusEnum
  #   end
  #
  #   order.payment_status.completed? # => true
  class Base
    class << self
      # @return [Hash] the enum values as a frozen hash
      attr_accessor :values

      # Define the enum values
      #
      # @param input [Hash, Array] Either a hash of symbol/string => integer pairs,
      #   or an array of symbols/strings (for string-based storage)
      # @example With integer values
      #   set_values pending: 0, active: 1, completed: 2
      # @example With string values
      #   set_values [:pending, :active, :completed]
      def set_values(input)
        case input
        when Hash
          @values = input.freeze
        when Array
          validate_array_elements!(input)
          @values = input.map { |item| [item.to_sym, item.to_s] }.to_h.freeze
        else
          raise ArgumentError, "Input must be a Hash or an Array of symbols or strings"
        end
      end

      # Returns all enum instances
      # @return [Array<SwifterEnum::Base>] array of all possible enum instances
      # @example
      #   StatusEnum.all_cases # => [#<StatusEnum @value=:pending>, ...]
      def all_cases
        @values.keys.map { |key| new(key) }
      end

      # Safe accessor that returns an enum instance for the given key
      #
      # @param key [Symbol] the enum value to retrieve (must be a Symbol)
      # @return [SwifterEnum::Base] new instance of the enum with the given value
      # @raise [ArgumentError] if key is not a Symbol
      # @raise [ArgumentError] if key doesn't exist in enum values
      # @example
      #   status = StatusEnum[:active] # => #<StatusEnum @value=:active>
      #   StatusEnum[:invalid] # raises ArgumentError
      def [](key)
        unless key.is_a?(Symbol)
          raise ArgumentError, "Enum key must be a Symbol, got #{key.class}"
        end

        unless @values.key?(key)
          raise ArgumentError, "Unknown enum value: :#{key}. Valid values are: #{@values.keys.map { |k| ":#{k}" }.join(", ")}"
        end

        new(key)
      end

      private

      def validate_array_elements!(array)
        unless array.all? { |item| item.is_a?(Symbol) || item.is_a?(String) }
          raise ArgumentError, "Array elements must all be symbols or strings"
        end
      end
    end

    # @return [Symbol] the underlying symbol value of this enum instance
    attr_accessor :value

    # Creates a new enum instance
    # @param value [Symbol, String, nil] the enum value
    def initialize(value)
      @value = value&.to_sym
    end

    # Flexible equality checking - works with symbols, strings, and other enum instances
    #
    # @param other [Symbol, String, SwifterEnum::Base] value to compare against
    # @return [Boolean] true if values are equal
    # @example
    #   status == :active          # => true
    #   status == "active"        # => true
    #   status == other_status     # => true if same value
    def ==(other)
      if other.is_a?(Symbol) || other.is_a?(String)
        value.to_s == other.to_s
      else
        other.instance_of?(self.class) && value == other.value
      end
    end

    # Check if this enum value is included in a collection
    # @param collection [Array] collection to check
    # @return [Boolean] true if this enum's value is in the collection
    # @example
    #   status.in?([:active, :pending]) # => true
    def in?(collection)
      collection.any? { |item| self == item }
    end

    # Returns the internationalized label for this enum value
    # @return [String] translated label from I18n
    # @example
    #   status.t # => "Active"
    def t
      I18n.t("swifter_enum.#{self.class.name.demodulize.underscore}.#{value}")
    end

    # @return [String] string representation of the enum value
    def to_s
      value.to_s
    end

    # Returns all enum instances (alias for all_cases)
    # @return [Array<SwifterEnum::Base>] array of all possible enum instances
    def self.all
      values.keys.map { |value| new(value) }
    end
  end
end