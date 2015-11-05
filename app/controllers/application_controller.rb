class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :require_login, except: [:not_authenticated]

  alias_method :current_user_orig, :current_user

  private
    def not_authenticated
      redirect_to show_login_path, :alert => 'Login required!'
    end

    def coach_client
      @coach_client || (@coach_client = Coach::Client.new)
    end

    def current_user
      u = current_user_orig
      return unless u
      u.coach_user = coach_client.users.find(u.username) if u.coach_user.nil?
      u
    end
end
