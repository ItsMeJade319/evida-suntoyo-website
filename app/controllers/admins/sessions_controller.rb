class Admins::SessionsController < Devise::SessionsController
  # Single-admin site with no "remember me" checkbox in the UI — every
  # sign-in is treated as "remember me" so the session survives browser
  # restarts and only ends when the admin explicitly signs out.
  #
  # Devise::Controllers::Rememberable#remember_me is the documented way to do
  # this outside of a params-driven checkbox (its own docs point to OmniAuth
  # callbacks as the standard use case — ours is the same shape).
  include Devise::Controllers::Rememberable

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    remember_me(resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_path
  end
end
