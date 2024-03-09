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
end
