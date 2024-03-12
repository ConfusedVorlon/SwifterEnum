require "test_helper"

class SwifterEnumValidationTest < Minitest::Test
  def test_is_valid
    model = TestModel.create!(emotion: :happy, size: :big)
    assert model.valid?
  end

  def test_can_not_set_bad_value
    model = TestModel.create!(emotion: :happy, size: :big)
    model.update_column(:emotion, "999")
    model.reload

    assert model.invalid?
  end

  def test_nil_value_gets_helpful_error
    model = TestModel.build(emotion: nil)
    model.valid?

    assert_includes model.errors[:emotion], "nil value for emotion is not allowed"
  end

  def test_nil_is_allowed_for_size
    model = TestModel.build(emotion: :happy, size: nil)
    assert model.valid?
  end
end
