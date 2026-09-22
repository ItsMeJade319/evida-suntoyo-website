require "test_helper"

class GuideTest < ActiveSupport::TestCase
  test "requires a title" do
    guide = Guide.new
    assert_not guide.valid?
    assert_includes guide.errors[:title], "can't be blank"
  end

  test "generates a slug from the title when left blank" do
    guide = Guide.new(title: "Hello, World!")
    guide.valid?
    assert_equal "hello-world", guide.slug
  end

  test "sets published_at when published for the first time" do
    guide = Guide.create!(title: "Announcing Something", published: true)
    assert_not_nil guide.published_at
  end

  test "published scope only includes published guides" do
    assert_includes Guide.published, guides(:one)
    assert_not_includes Guide.published, guides(:two)
  end

  test "can have an image attached" do
    guide = guides(:one)
    guide.image.attach(io: StringIO.new("fake image content"), filename: "test.png", content_type: "image/png")
    assert guide.image.attached?
  end

  test "orders steps by position" do
    assert_equal [ guide_steps(:one), guide_steps(:two) ], guides(:one).steps.to_a
  end
end
