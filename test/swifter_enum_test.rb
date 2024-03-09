require "test_helper"

class ReadWriteTest < Minitest::Test
  # Getters

  # Emotion is an instance of EmotionEnum
  # You can always get the underlying enum symbol from the value method

  def test_enum_read_value
    model = TestModel.build(emotion: :happy)

    assert_equal model.emotion.value, :happy
  end

  # Setters

  # You can set the value with a symbol
  # model.emotion = :angry
  #
  # or with another enum
  # model.emotion = EmotionEnum.new(:angry)
  #
  # you may well be getting that other enum from a different instance
  # model.emotion = other_instance.emotion

  def test_setter_with_symbol
    model = TestModel.create!(emotion: :happy)
    model.emotion = :angry
    model.save

    assert_equal :angry, model.reload.emotion.value
  end

  def test_setter_with_enum
    model = TestModel.create!(emotion: :happy)
    model.emotion = EmotionEnum.new(:angry)
    model.save

    assert_equal :angry, model.reload.emotion.value
  end

  # Equality

  # Equality testing is very permissive.
  # You can test against string, symbol or EmotionEnum
  #
  # model.emotion == :happy #true
  # model.emotion == 'happy' #true
  # model.emotion == EmotionEnum.new(:happy)

  def test_equality_with_symbol
    model = TestModel.create!(emotion: :happy)

    assert model.emotion == :happy
  end

  def test_equality_with_string
    model = TestModel.create!(emotion: :happy)

    assert model.emotion == "happy"
  end

  def test_equality_with_enum_class
    model = TestModel.create!(emotion: :happy)

    assert model.emotion == EmotionEnum.new(:happy)
  end

  # SwifterEnum methods work

  # The whole point of this is to let you provide additonal methods to your enumb
  #
  # model.emotion.emoji => "😁"

  def test_enum_methods
    model = TestModel.create!(emotion: :happy, size: :big)

    assert_equal "😁", model.emotion.emoji
    assert_equal 8, model.size.height_ft
  end

  def test_enum_values
    assert_equal TestModel.sizes, {big: 0, small: 1}.transform_keys(&:to_s)
  end

  # Convenience methods still work

  # You can still use the convenience methods that a regular enum would define
  # (the regular enum _has_ been defined!)
  #
  # model.happy? #checks if model.emotion == :happy
  # model.happy! #sets model.emotion = :happy

  def test_convenience_getter
    model = TestModel.create!(emotion: :happy, size: :big)

    # emotion is defined as a regular enum
    # swifter_enum :emotion, EmotionEnum
    assert model.happy?

    # size is defined with _prefix: true
    # swifter_enum :size, SizeEnum,  _prefix: true
    assert model.size_big?
  end

  def test_convenience_setter
    model = TestModel.create!(emotion: :happy, size: :big)

    model.angry!
    assert :angry, model.emotion.value

    model.size_small!
    assert :small, model.size.value
  end

  # Localisation

  # localisation checks for values in
  # <language>.swifter_enum.emotion_enum.<value>

  def test_localisation
    model = TestModel.create!(emotion: :happy, size: :big)
    assert_equal "Localised Happy", model.emotion.t
  end

  # Escape Hatch

  # If you're using a framework that is set up for a standard enum, then you can use the 'escape hatch' raw enum
  # model.emotion_raw behaves like model.emotion would if it was a regular enum
  # this is great for adminstrate dashboards as an example

  def test_raw_getter
    model = TestModel.create!(emotion: :happy, size: :big)
    assert_equal "happy", model.emotion_raw
  end

  def test_raw_setter
    model = TestModel.create!(emotion: :happy, size: :big)
    model.emotion_raw = "angry"

    assert_equal :angry, model.emotion.value
  end

  def test_values
    assert_equal TestModel.size_raws, {big: 0, small: 1}.transform_keys(&:to_s)
  end
end
