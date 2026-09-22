class Admin::GuidesController < Admin::BaseController
  def index
    @guides = Guide.order(created_at: :desc)
  end
end
