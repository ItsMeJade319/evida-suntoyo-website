require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "requires a title" do
    post = Post.new
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "generates a slug from the title when left blank" do
    post = Post.new(title: "Hello, World!")
    post.valid?
    assert_equal "hello-world", post.slug
  end

  test "sets published_at when published for the first time" do
    post = Post.create!(title: "Announcing Something", published: true)
    assert_not_nil post.published_at
  end

  test "published scope only includes published posts" do
    assert_includes Post.published, posts(:one)
    assert_not_includes Post.published, posts(:two)
  end

  test "can have an image attached" do
    post = posts(:one)
    post.image.attach(io: StringIO.new("fake image content"), filename: "test.png", content_type: "image/png")
    assert post.image.attached?
  end
end
