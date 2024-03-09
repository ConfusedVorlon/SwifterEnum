require "test_helper"

class SwifterEnumEscapeHatchTest < Minitest::Test
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
