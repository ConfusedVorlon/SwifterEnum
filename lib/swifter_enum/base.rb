module SwifterEnum
  class Base
    class << self
      attr_accessor :values

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

      def all_cases
        @values.keys.map { |key| new(key) }
      end

      private

      def validate_array_elements!(array)
        unless array.all? { |item| item.is_a?(Symbol) || item.is_a?(String) }
          raise ArgumentError, "Array elements must all be symbols or strings"
        end
      end
    end

    attr_accessor :value

    def initialize(value)
      @value = value&.to_sym
    end

    def ==(other)
      if other.is_a?(Symbol) || other.is_a?(String)
        value.to_s == other.to_s
      else
        other.instance_of?(self.class) && value == other.value
      end
    end

    def t
      return nil if value.nil?

      I18n.t("swifter_enum.#{self.class.name.demodulize.underscore}.#{value}")
    end

    def to_s
      value.to_s
    end

    def self.all
      values.keys.map { |value| new(value) }
    end
  end
end
