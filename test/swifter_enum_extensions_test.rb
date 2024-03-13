require "test_helper"

class SwifterEnumExtensionsTest < Minitest::Test
  # Getters

  # Emotion is an instance of EmotionEnum
  # You can always get the underlying enum symbol from the value method

  def test_enum_read_value
    assert_equal SizeEnum.all_cases, [SizeEnum.new(:big), SizeEnum.new(:small)]
  end

  def test_to_s
    assert_equal SizeEnum.new(:big).to_s, "big"
  end
end
