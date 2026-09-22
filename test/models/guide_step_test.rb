require "test_helper"

class GuideStepTest < ActiveSupport::TestCase
  test "requires a title" do
    step = GuideStep.new
    assert_not step.valid?
    assert_includes step.errors[:title], "can't be blank"
  end

  test "belongs to a guide" do
    assert_equal guides(:one), guide_steps(:one).guide
  end
end
