class EmotionEnum < SwifterEnum::Base
  def self.values
    {confused: 0, happy: 1, angry: 2, tired: 3}.freeze
  end

  def emoji
    case @value
    when :confused
      "🤔"
    when :happy
      "😁"
    when :angry
      "😡"
    when :tired
      "😴"
    end
  end
end
