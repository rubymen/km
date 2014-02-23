class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403.html", status: 403
  end

  protect_from_forgery with: :exception
end
