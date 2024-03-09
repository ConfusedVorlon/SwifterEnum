require "test_helper"

class ReadWriteTest < Minitest::Test
  def test_enum_behavior
    model = TestModel.build(name: "Test", status: :happy)

    assert_equal model.status.value, :happy
  end
end
