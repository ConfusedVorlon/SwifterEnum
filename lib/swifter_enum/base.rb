module SwifterEnum
  class Base
    attr_reader :value

    def self.values
      {}
    end

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
      I18n.t("swifter_enum.#{self.class.name.demodulize.underscore}.#{@value}")
    end

    def to_s
      @value
    end

    def self.all
      values.keys.map { |value| new(value) }
    end
  end
end
