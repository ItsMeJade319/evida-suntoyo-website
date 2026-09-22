class Admin::PostsController < Admin::BaseController
  def index
    @posts = Post.order(created_at: :desc)
  end
end
