class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :require_login, except: [:not_authenticated]

  private
    def not_authenticated
      redirect_to show_login_path, :alert => 'Login required!'
    end
end
