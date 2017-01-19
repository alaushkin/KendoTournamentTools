class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception
  def hello
     redirect_to '/views/tournament/page?num=1&per_page=10'
  end

  def check_user
    if !user_signed_in?
      redirect_to '/sign_in'
      return false
    end
    if !current_user.has_role? :admin
      @message = 'У пользователя нет прав для этого действия'
      render 'errors/error'
      return false
    end
    return true
  end
end
