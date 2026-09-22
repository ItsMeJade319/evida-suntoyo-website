class AdminController < ApplicationController
  before_action :authenticate_admin!

  def show
    @guides = Guide.order(created_at: :desc)
    @posts = Post.order(created_at: :desc)
    @recent_guides = @guides.first(4)
    @recent_posts = @posts.first(4)
    @drafts = (@guides.to_a + @posts.to_a).reject(&:published?).sort_by(&:created_at).reverse
  end
end
