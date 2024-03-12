require "test_helper"

class SwifterEnumBasicsTest < Minitest::Test
  # Getters

  # Emotion is an instance of EmotionEnum
  # You can always get the underlying enum symbol from the value method

  def test_enum_read_value
    assert_equal SizeEnum.all_cases, [SizeEnum.new(:big),SizeEnum.new(:small)]
  end

end
