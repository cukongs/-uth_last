class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  # before_action :authenticate_user!
  # before_filter :login_required, :except => [:new, :create]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_user_positions

  def check_user_positions
    if current_user
      if !current_user.positions.present?
        update_user_positions(current_user)
      end
    end
  end
end
