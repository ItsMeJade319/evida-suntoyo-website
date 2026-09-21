require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "requires a title" do
    project = Project.new
    assert_not project.valid?
    assert_includes project.errors[:title], "can't be blank"
  end

  test "orders by position" do
    assert_equal [ projects(:one), projects(:two) ], Project.ordered.to_a
  end
end
