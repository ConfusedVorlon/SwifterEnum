class SizeEnum < SwifterEnum::Base
  def self.values
    {big: 0, small: 1}.freeze
  end

  def height_ft
    case @value
    when :big
      8
    when :small
      5
    end
  end
end
