class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception
  def hello
     redirect_to '/views/tournament/page?num=1&per_page=10'
  end
end
