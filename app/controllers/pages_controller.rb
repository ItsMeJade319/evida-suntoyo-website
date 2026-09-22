class PagesController < ApplicationController
  def about
    @recent_guides = Guide.published.limit(4)
    @recent_posts = Post.published.limit(2)
  end

  def resume
  end
end
