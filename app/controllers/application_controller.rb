class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_filter :require_login, except: [:not_authenticated]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private
    def not_authenticated
      redirect_to show_login_path, :alert => 'Login required!'
    end

    def user_not_authorized
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to(request.referrer || root_path)
    end

    def record_not_found
      flash[:alert] = 'This entity does not exist!'
      redirect_to(request.referrer || root_path)
    end

    def coach_client
      @coach_client || (@coach_client = Coach::Client.new)
    end
end
