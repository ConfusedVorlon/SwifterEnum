require "test_helper"

class SwifterEnumBracketAccessorTest < Minitest::Test
  def test_bracket_accessor_returns_enum_instance
    emotion = EmotionEnum[:happy]

    assert_instance_of EmotionEnum, emotion
    assert_equal :happy, emotion.value
  end

  def test_bracket_accessor_works_with_integer_mapped_enum
    emotion = EmotionEnum[:confused]

    assert_instance_of EmotionEnum, emotion
    assert_equal :confused, emotion.value
  end

  def test_bracket_accessor_works_with_string_mapped_enum
    size = SizeEnum[:big]

    assert_instance_of SizeEnum, size
    assert_equal :big, size.value
  end

  def test_bracket_accessor_raises_error_for_invalid_value
    error = assert_raises(ArgumentError) do
      EmotionEnum[:nonexistent]
    end

    assert_match(/Unknown enum value: :nonexistent/, error.message)
    assert_match(/Valid values are: :confused, :happy, :angry, :tired/, error.message)
  end

  def test_bracket_accessor_raises_error_for_string_key
    error = assert_raises(ArgumentError) do
      EmotionEnum["happy"]
    end

    assert_equal "Enum key must be a Symbol, got String", error.message
  end

  def test_bracket_accessor_raises_error_for_integer_key
    error = assert_raises(ArgumentError) do
      EmotionEnum[1]
    end

    assert_equal "Enum key must be a Symbol, got Integer", error.message
  end

  def test_bracket_accessor_raises_error_for_nil_key
    error = assert_raises(ArgumentError) do
      EmotionEnum[nil]
    end

    assert_equal "Enum key must be a Symbol, got NilClass", error.message
  end

  def test_bracket_accessor_returns_equivalent_instance_to_new
    from_bracket = EmotionEnum[:happy]
    from_new = EmotionEnum.new(:happy)

    assert_equal from_bracket.value, from_new.value
    assert_equal from_bracket, from_new
  end

  def test_bracket_accessor_can_be_used_to_set_model_attributes
    model = TestModel.new
    model.emotion = EmotionEnum[:angry]

    assert_equal :angry, model.emotion.value
  end

  def test_bracket_accessor_instances_have_access_to_methods
    emotion = EmotionEnum[:happy]

    assert_equal "😁", emotion.emoji
  end
end
