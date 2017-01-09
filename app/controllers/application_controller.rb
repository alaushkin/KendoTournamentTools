class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception
  def hello
     render text: "HALLO, world!"
  end
  def test
    render text: "TEST"
  end
end
