module SwifterEnum
  class Base

    attr_reader :value

    def self.values
      {}
    end

    def initialize(value)
      @value = value.to_sym
    end

    def ==(other)
      other.instance_of?(self.class) && self.value == other.value
    end

    def t
      I18n.t("swifter_enum.#{self.class.name.demodulize.underscore}.#{@value}")
    end

    def to_s
      @value
    end

    def self.all
      self.values.keys.map{|value| new(value)}
    end

  end
end
