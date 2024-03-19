require "test_helper"

class SwifterEnumLocalisationTest < Minitest::Test
  # Localisation

  # localisation checks for values in
  # <language>.swifter_enum.emotion_enum.<value>

  def test_localisation
    model = TestModel.create!(emotion: :happy, size: :big)
    assert_equal "Localised Happy", model.emotion.t
  end

  def test_localisation_for_nil
    model = TestModel.create!(emotion: :happy, size: nil)
    assert_equal nil, model.size.t
  end
end
