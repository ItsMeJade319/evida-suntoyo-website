class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  # Redirects back to wherever the user started the action from (carried via a
  # `return_to` param through the form/link), falling back to a default path.
  # Only same-site paths are honored, to avoid open-redirect issues.
  def safe_redirect_target(fallback)
    candidate = params[:return_to]
    if candidate.present? && candidate.start_with?("/") && !candidate.start_with?("//")
      candidate
    else
      fallback
    end
  end
end
