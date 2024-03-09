class EmotionEnum < SwifterEnum::Base
  def self.values
    { confused: 0, happy: 1, angry: 2, tired: 3 }.freeze
  end

  def emoji
    case @value
    when :confused
      return "🤔"
    when :happy
      return "😁"
    when :angry
      return "😡"
    when :tired
      return "😴"
    end
  end
end